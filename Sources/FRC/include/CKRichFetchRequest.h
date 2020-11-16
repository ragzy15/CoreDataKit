//
//  CKRichFetchRequest.h
//  FRC
//
//  Created by Raghav Ahuja on 11/10/20.
//  Copyright © 2020 Raghav Ahuja. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CKRichFetchRequest<ResultType: id<NSFetchRequestResult>> : NSFetchRequest<ResultType>

@end

NS_ASSUME_NONNULL_END
