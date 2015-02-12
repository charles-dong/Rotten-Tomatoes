//
//  MovieDetailVC.m
//  Rotten Tomatoes
//
//  Created by Charles Dong on 2/6/15.
//  Copyright (c) 2015 Charles Dong. All rights reserved.
//

#import "MovieDetailVC.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailVC ()

@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation MovieDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.movie[@"title"];
    
    // set text
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"synopsis"];
    [self.synopsisLabel sizeToFit];
    
    // scroll view
    self.scroll.contentSize = CGSizeMake(self.scroll.frame.size.width, self.synopsisLabel.frame.size.height + 100);
    
    // set image
    NSString *tempString = [self.movie valueForKeyPath:@"posters.thumbnail"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:tempString]];
    [self.movieImage setImageWithURLRequest:request
                           placeholderImage:nil
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        self.movieImage.image = image;
                                        self.movieImage.alpha = 0.0;
                                        [UIView animateWithDuration:1
                                                         animations:^{
                                                             self.movieImage.alpha = 1.0;
                                                         }];
                                        NSString *url = [tempString stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
                                        NSURLRequest *oriRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
                                        [self.movieImage setImageWithURLRequest:oriRequest
                                                               placeholderImage:nil
                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                            self.movieImage.image = image;
                                                                            self.movieImage.alpha = 0.0;
                                                                            [UIView animateWithDuration:1
                                                                                             animations:^{
                                                                                                 self.movieImage.alpha = 1.0;
                                                                                             }];
                                                                            
                                                                        }
                                                                        failure:NULL
                                         ];
                                        
                                    }
                                    failure:NULL
     ];
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
