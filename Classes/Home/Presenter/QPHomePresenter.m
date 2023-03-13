//
//  QPHomePresenter.m
//
//  Created by chenxing on 2015/6/18. ( https://github.com/chenxing640/QPlayer )
//  Copyright (c) 2015 chenxing. All rights reserved.
//

#import "QPHomePresenter.h"
#import "QPHomeListViewAdapter.h"
#import "QPFileTableViewCell.h"
#import "QPPlayerController.h"

@interface QPHomePresenter () <QPListViewAdapterDelegate>
@property (nonatomic, strong) NSMutableArray *localFileList;
@property (nonatomic, strong) NSMutableArray *fileList;
@end

@implementation QPHomePresenter

- (instancetype)init
{
    return [self initWithViewController:nil];
}

- (instancetype)initWithViewController:(QPBaseViewController *)viewController
{
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)setView:(QPHomeView *)view
{
    _view = view;
    [self configure];
}

- (void)setupFileResourceDelegate
{
    [QPWifiManager shared].httpServer.fileResourceDelegate = self;
}

/// Load local file list.
- (void)loadLocalFileList
{
    // remove all objects.
    [self.localFileList removeAllObjects];
    
    NSArray *files = [QPFileHelper localVideoFiles];
    [self.localFileList addObjectsFromArray:files];
    
    // sort objects.
    [self.localFileList sortUsingFunction:QPSortObjects context:NULL];
}

/// Load file list.
- (void)loadFileList
{
    [self.fileList removeAllObjects];
    
    NSString *path = [QPFileHelper cachePath];
    NSDirectoryEnumerator *dirEnum = [QPFileMgr enumeratorAtPath:path];
    
    NSString *name = nil;
    while (name = [dirEnum nextObject]) {
        [self.fileList addObject:name];
    }
}

#pragma mark - loadData

- (QPHomeViewController *)homeViewController
{
    return (QPHomeViewController *)_viewController;
}

- (void)configure
{
    [self setupFileResourceDelegate];
    [self loadLocalFileList];
    self.view.adapter.listViewDelegate = self;
    @QPWeakify(self)
    [self.view reloadData:^{
        [weak_self loadData];
    }];
    [self updateDataSource];
}

- (void)reloadData
{
    [self delayToScheduleTask:1.2 completion:^{
        [self loadData];
    }];
}

- (void)loadData
{
    [self loadFileList];
    [self updateDataSource];
}

- (void)updateDataSource
{
    [_view.adapter.dataSource removeAllObjects];
    [_view.adapter.dataSource addObjectsFromArray:self.localFileList];
    [_view reloadUI];
}

#pragma mark - WebFileResourceDelegate

// number of the files.
- (NSInteger)numberOfFiles
{
    QPLog("::");
    return [self.fileList count];
}

// the file name by the index.
- (NSString *)fileNameAtIndex:(NSInteger)index
{
    QPLog(":: index=%zi", index);
    return [self.fileList objectAtIndex:index];
}

// provide full file path by given file name.
- (NSString *)filePathForFileName:(NSString *)filename
{
    QPLog(":: filename=%@", filename);
    return QPAppendingPathComponent([QPFileHelper cachePath], filename);
}

// handle newly uploaded file. After uploading, the file is stored in
// the temparory directory, you need to implement this method to move
// it to proper location and update the file list.
- (void)newFileDidUpload:(NSString *)name inTempPath:(NSString *)tmpPath
{
    QPLog(":: filename=%@, tmpPath=%@", name, tmpPath);
    if (name == nil || tmpPath == nil) return;
    
    NSString *path = QPAppendingPathComponent([QPFileHelper cachePath], name);
    NSError *error = nil;
    if (![QPFileMgr moveItemAtPath:tmpPath toPath:path error:&error]) {
        QPLog(@":: can not move %@ to %@ because: %@", tmpPath, path, error);
    }
    
    [self loadFileList];
    [self loadLocalFileList];
    [self updateDataSource];
}

// implement this method to delete requested file and update the file list.
- (void)fileShouldDelete:(NSString *)fileName
{
    QPLog(":: filename=%@", fileName);
    
    NSString *path = [self filePathForFileName:fileName];
    NSError *error = nil;
    if(![QPFileMgr removeItemAtPath:path error:&error]) {
        QPLog(@":: %@ can not be removed because: %@", path, error);
    }
    
    [self loadFileList];
    [self loadLocalFileList];
    [self updateDataSource];
}

#pragma mark - QPListViewAdapterDelegate

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    return UITableViewAutomaticDimension; //100.f;
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    static NSString *cellID = @"QPFileCellIdentifier";
    QPHomeViewController *vc = [self homeViewController];
    QPFileTableViewCell *cell = [_view.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle.mainBundle loadNibNamed:NSStringFromClass([QPFileTableViewCell class]) owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    QPHomeListViewAdapter *_adapter = (QPHomeListViewAdapter *)adapter;
    [_adapter bindModelTo:cell atIndexPath:indexPath inTableView:_view.tableView withViewController:vc];
    
    return cell;
}

- (void)selectCell:(QPBaseModel *)model atIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    QPFileModel *_model = (QPFileModel *)model;
    if (!QPPlayerIsPlaying()) {
        NSURL *url                  = [NSURL fileURLWithPath:_model.path];
        UIImage *thumbnail          = self.yf_videoThumbnailImage(url, 3, 107, 60);
        QPPlayerModel *model        = [[QPPlayerModel alloc] init];
        model.isLocalVideo          = YES;
        model.isZFPlayerPlayback    = YES;
        model.videoTitle            = _model.name;
        model.videoUrl              = _model.path;
        model.placeholderCoverImage = thumbnail;
        QPPlayerController *qpc     = [[QPPlayerController alloc] initWithModel:model];
        [[self homeViewController].navigationController pushViewController:qpc animated:YES];
    }
}

- (BOOL)deleteCell:(QPBaseModel *)model atIndexPath:(NSIndexPath *)indexPath forAdapter:(QPListViewAdapter *)adapter
{
    QPFileModel *fileModel = (QPFileModel *)model;
    if ([QPFileHelper removeLocalFile:fileModel.name]) {
        // Delete data for datasource, delete row from table.
        [self.localFileList removeObjectAtIndex:indexPath.row];
        QPHomeListViewAdapter *_adapter = (QPHomeListViewAdapter *)adapter;
        if (_adapter) {
            if (_view.tableView.numberOfSections > 1) {
                NSArray *rowsArray = _adapter.dataSource[indexPath.section];
                NSMutableArray *mRowsArray = rowsArray.mutableCopy;
                [mRowsArray removeObjectAtIndex:indexPath.row];
                [_adapter.dataSource replaceObjectAtIndex:indexPath.section withObject:mRowsArray];
            } else {
                [_adapter.dataSource removeObjectAtIndex:indexPath.row];
            }
        }
        return YES;
    }
    return NO;
}

#pragma mark - lazy load

- (NSMutableArray *)localFileList
{
    if (!_localFileList) {
        _localFileList = [NSMutableArray arrayWithCapacity:0];
    }
    return _localFileList;
}

- (NSMutableArray *)fileList
{
    if (!_fileList) {
        _fileList = [NSMutableArray arrayWithCapacity:0];
    }
    return _fileList;
}

#pragma mark - dealloc

- (void)dealloc
{
    [QPWifiManager shared].httpServer.fileResourceDelegate = nil;
}

@end
