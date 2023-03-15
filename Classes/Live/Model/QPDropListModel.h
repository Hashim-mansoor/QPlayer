//
//  QPDropListModel.h
//
//  Created by chenxing on 2017/6/28.
//  Copyright © chenxing dyf. All rights reserved.
//

#import "QPBaseModel.h"

@interface QPDropListModel : QPBaseModel

// Returns a title string.
@property (nonatomic, copy) NSString *m_title;

// Returns a content string.
@property (nonatomic, copy) NSString *m_content;

@end
