/**
 * @author dommy <shonan.shachu at gmail.com>
 * @version 1.0.0 updated on 2012-05-16
 */

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UIActionSheetDelegate,
        UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) IBOutlet UIBarButtonItem *cameraButton;

@property (nonatomic, retain) IBOutlet UIImageView *thumbView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;

@end
