//
//  MoviesViewController.m
//  Rotten Tomatoes
//
//  Created by Charles Dong on 2/4/15.
//  Copyright (c) 2015 Charles Dong. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailVC.h"
#import "SVProgressHUD.h"

//https://github.com/DramaFever/DFProgressHUD

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (void)fetchMovies:(BOOL)refresh;
- (void)onRefresh;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Movies";
    
    // hide error
    [self.errorView setHidden:YES];
    
    // Configure the refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // setup tableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    
    // setup tab bar
    self.tabBar.delegate = self;
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
    [self.tabBar setTintColor:[UIColor whiteColor]];
    
    // register movie cell
    UINib *movieCellNib = [UINib nibWithNibName:@"MovieCell" bundle:nil];
    [self.tableView registerNib:movieCellNib forCellReuseIdentifier:@"MovieCell"];
    
    // get data
    [self fetchMovies:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    cell.movieImage.image = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    // set cell properties with appropriate movie
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    NSString *tempString = [movie valueForKeyPath:@"posters.thumbnail"];
    NSString *url = [tempString stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
    NSLog(@"Movie Picture URL: %@", url);
    [cell.movieImage setImageWithURL:[NSURL URLWithString:url]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // deselect
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // push detail vc
    MovieDetailVC *detailvc = [[MovieDetailVC alloc] init];
    detailvc.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:detailvc animated:YES];
}


#pragma mark - Tab Bar Methods

- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self fetchMovies:NO];
    if ([[self.tabBar items] indexOfObject:item] == 0) {
        self.title = @"Movies";
    } else {
        self.title = @"DVDs";
    }
}


#pragma mark - Private Methods


- (void)fetchMovies:(BOOL)refresh {
    // show HUD
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // choose box-office or DVD url based on tab bar
        NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=ekuj79ez2bjnjk5dup2r98d4"];
        if ([[self.tabBar items] indexOfObject:self.tabBar.selectedItem] == 0) {
             url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ekuj79ez2bjnjk5dup2r98d4"];
        }
        
        // get movies
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            
            // handle network error
            if (connectionError != nil) {
                [self.errorView setHidden:NO];
                self.errorLabel.text = [connectionError localizedDescription];
                
            } else {
                [self.errorView setHidden:YES];
            
                // get movies
                self.movies = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"movies"];
                NSLog(@"Movies Array: %@", self.movies);
                NSLog(@"Movie count: %lu", (unsigned long)self.movies.count);
                [self.tableView reloadData];
            }
            
            // dismiss HUD
            dispatch_async(dispatch_get_main_queue(), ^{
                //[NSThread sleepForTimeInterval:1.0f];
                [SVProgressHUD dismiss];
            });
        
        }];
    });
    
    if (refresh) {
        [self.refreshControl endRefreshing];
    }
}

- (void) onRefresh {
    [self fetchMovies:YES];
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
