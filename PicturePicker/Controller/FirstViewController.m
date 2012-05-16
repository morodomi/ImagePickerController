/**
 * @author dommy <shonan.shachu at gmail.com>
 * @version 1.0.0 updated on 2012-05-16
 */

#import "FirstViewController.h"
#import <AssetsLibrary/ALAsset.h>

@interface FirstViewController ()
- (void)onClickCameraButton;
@end

@implementation FirstViewController
@synthesize cameraButton;
@synthesize thumbView;
@synthesize imageView;
@synthesize toolbar;
- (void)dealloc {
    [cameraButton release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [cameraButton setTarget:self];
    [cameraButton setAction:@selector(onClickCameraButton)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)onClickCameraButton {
    // Action Sheetの表示
    UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
    [actionSheet setDelegate:self];
    [actionSheet setTitle:@"Choose Picture"];
    [actionSheet addButtonWithTitle:@"Choose From the Library"];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:@"Take Picture"];
        [actionSheet setCancelButtonIndex:2];
    }else{
        [actionSheet setCancelButtonIndex:1];
    }
    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet showFromToolbar:toolbar];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    [imagePicker setDelegate:self];
    switch (buttonIndex) {
        case 0:
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentModalViewController:imagePicker animated:YES];
            break;
        case 1:
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentModalViewController:imagePicker animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        CGImageRef thumbrefs = [myasset thumbnail];
        if (thumbrefs) {
            UIImage *thumbnail = [UIImage imageWithCGImage:thumbrefs];
            [thumbView setImage:thumbnail];
        }
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        UIImage *image = [UIImage imageWithCGImage:[representation fullResolutionImage]
                                           scale:[representation scale]
                                     orientation:[representation orientation]];
        [imageView setImage:image];
    };
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
    };

    if(imageURL) {
        ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
        [assetslibrary assetForURL:imageURL 
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}
@end
