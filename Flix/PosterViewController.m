//
//  PosterViewController.m
//  Flix
//
//  Created by Sabrina P Meng on 6/24/21.
//

#import "PosterViewController.h"
#import "UIImageView+AFNetworking.h"
#import "FullPosterViewController.h"

@interface PosterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel2;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

@end

@implementation PosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.movie[@"title"];
    
    // Poster image
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    
    // Background image
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    [self.backdropView setImageWithURL:backdropURL];
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    
    // Obtaining rating float
    NSNumber *ratingObj = self.movie[@"vote_average"];
    float rating = [ratingObj floatValue];
    
    // Obtaining vote count integer
    NSNumber *voteCountObj = self.movie[@"vote_count"];
    int voteCount = [voteCountObj intValue];
    self.infoLabel.text = [NSString stringWithFormat:@"Rating: %.1f/10 (%d votes)", rating, voteCount];
    NSString *releaseDateString = [@"Release Date: " stringByAppendingString:self.movie[@"release_date"]];
    self.infoLabel2.text = releaseDateString;
    // [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
    [self.posterView setUserInteractionEnabled:true];
    [self.posterView addGestureRecognizer:self.tapRecognizer];
}

-(void)viewDidAppear:(BOOL)animated {
}

-(void)viewWillAppear:(BOOL)animated {
    // Loads in user-picked color and dark mode settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool darkModeStatus = [defaults boolForKey:@"dark_mode_on"];
    int navColor = [defaults integerForKey:@"nav_color"];
    
    // Set bar color
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.barTintColor = [self colorWithHex:navColor];
    self.tabBarController.tabBar.barTintColor = [self colorWithHex:navColor];
    
    // Set dark mode or light mode
    if (darkModeStatus) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }
    else {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}

// UIColor from hex color
-(UIColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FullPosterViewController *fullPosterViewController = [segue destinationViewController];
    fullPosterViewController.movie = self.movie;
}


@end
