

#import "FrontViewController.h"
#import <MapKit/MKFoundation.h>

@interface FrontViewController ()
{

CLLocation *userLocation;
    NSString *bloodSelected;
    NSMutableDictionary * dictonaryToPost;
     NSMutableDictionary * dictonaryForDonar;
     NSDictionary *dictonaryForInfo;
    NSMutableArray *arrayOfDonars;
   UITableView *tableViewForSettings;
     CLLocationManager *locationManager;
    UIStoryboard *storyboard;
  
}

@end

@implementation FrontViewController



@synthesize layoutConstraintHeightForTable;
@synthesize tableViewBloodList;
@synthesize donorsDisplayViewController;


- (void)viewDidLoad {
  
    [super viewDidLoad];
       NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    self.navigationController.navigationBarHidden = true;
    storyboard = [UIStoryboard storyboardWithName:MAIN bundle:nil];

    if(![[[defaults dictionaryRepresentation] allKeys] containsObject:USER])
    {
       
        RegistrationPageViewController *registration = [storyboard instantiateViewControllerWithIdentifier:@"RegistrationPageViewController"];
        NSLog(@"%@",self.navigationController);
        [self.navigationController pushViewController:registration animated:NO];

    }
    
       layoutConstraintHeightForTable.constant = 0;
       [self gettingCurrentLocation];
    NSLog(@"%f",userLocation.coordinate.latitude);
    locationManager.pausesLocationUpdatesAutomatically = YES;    
    arrayOfDonars = [[NSMutableArray alloc]init];
    dictonaryForInfo = @{@"data":@[
                                 @{
                                     @"id":@1234,
                                     @"name":@"Sandeep Rathore",
                                     @"phone":@"+918149325524",
                                     @"email":@"sandeep.rathore@weboniselab.com",
                                     @"lat":@19.017615,
                                     @"lng":@72.856164
                                     },
                                 @{
                                     @"id":@3243,
                                     @"name":@"Chirag",
                                     @"phone":@"+918149325524",
                                     @"email":@"chirag@weboniselab.com",
                                     @"lat":@28.538048,
                                     @"lng":@73.786755
                                     },
                                 @{
                                     @"id":@3424,
                                     @"name":@"Hardik Trivedi",
                                     @"phone":@"+918149325524",
                                     @"email":@"hardik.trivedi@weboniselab.com",
                                     @"lat":@18.517214,
                                     @"lng":@73.780489
                                     },
                                 ],
                         @"error": @{
                                 @"errorCode":@400,
                                 @"message":@""
                                 },
                         @"status": @{
                                 @"statusCode":@200,
                                 @"message":@"Success"
                                 }
                         };
    NSLog(@"%@",self.navigationController);
  
bloodSelected = @"o+";
    [self parseData];
    
    
    
    

}




-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBarHidden = true;
    layoutConstraintHeightForTable.constant = 0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark :- parsing json

-(void)parseData{
    NSLog(@"%@",[dictonaryForInfo valueForKeyPath:@"error.errorCode" ] );
    if([[dictonaryForInfo valueForKeyPath:@"status.statusCode" ] isEqualToValue: @200] )
    {
        NSMutableDictionary *donar;
        for(donar in [dictonaryForInfo valueForKey:@"data"])
        {
            Donor *donarInfo = [[Donor alloc]init];
            
            donarInfo.name = [donar valueForKey:NAME];
            
            donarInfo.email = [donar valueForKey:EMAIL];
            donarInfo.phoneNo = [donar valueForKey:PHONENO];
            donarInfo.lattitude = [[donar valueForKey:LATTITUDE] integerValue];
            donarInfo.longitude  = [[ donar valueForKey:LONGITUDE] integerValue];
            [arrayOfDonars addObject:donarInfo];
        }
        
    }
}



- (IBAction)buttonHistoryAction:(id)sender {
    
    HistoryListViewController *historyListViewController  = [storyboard instantiateViewControllerWithIdentifier:@"HistoryListViewController"];
    [self.navigationController pushViewController:historyListViewController animated:YES];
    
}
- (IBAction)buttonSearchBloodAction:(id)sender {
    layoutConstraintHeightForTable.constant = 182;
    [tableViewBloodList registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [tableViewBloodList reloadData];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [tableViewForSettings removeFromSuperview];
    layoutConstraintHeightForTable.constant = 0;
}
- (IBAction)barButtonSettingAction:(id)sender {
    
    
    if(![tableViewForSettings isDescendantOfView:self.view]) {
        tableViewForSettings=[[UITableView alloc]init];
        tableViewForSettings.frame = CGRectMake(35,30,120,80);
        
        tableViewForSettings.dataSource= self;
        tableViewForSettings.delegate=self;
        [tableViewForSettings registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
        [tableViewForSettings reloadData];
        
        [self.view addSubview:tableViewForSettings];
    }
    else {
        [tableViewForSettings removeFromSuperview];
    }
    
    
}
#pragma mark - current location

-(void)gettingCurrentLocation{

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
  
    [locationManager requestWhenInUseAuthorization];
    
    
    [locationManager startUpdatingLocation];


}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    
        userLocation = [locations lastObject];
    
        NSLog(@"%f",userLocation.coordinate.latitude);
        NSLog(@"%f",userLocation.coordinate.latitude);
    [locationManager stopUpdatingLocation];
    
    }


#pragma mark - setting's Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == tableViewForSettings){
        return SETTINGLIST.count;
    }
    else{
        return BLOODTYPES.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == tableViewForSettings){
        UITableViewCell *cell = [[UITableViewCell alloc]init] ;
        cell.textLabel.text = [SETTINGLIST objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor colorWithRed:77.0/255.0f green:104.0/255.0f blue:159.0/255.0f alpha:1.0];  ;
        
        return cell;
    }
    else{
        UITableViewCell *cell = [[UITableViewCell alloc]init] ;
        cell.textLabel.text = [BLOODTYPES objectAtIndex:indexPath.row];
        
        return cell;
        
        
    }
}

#pragma mark - Selecting row on table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    if(tableView == tableViewBloodList){
            self.navigationController.navigationBarHidden = false;
        layoutConstraintHeightForTable.constant = 0;
       DonorsDisplayViewController *donorsDisplayViewController1 = [storyboard instantiateViewControllerWithIdentifier:@"DonorsDisplayViewController"];
        bloodSelected = [BLOODTYPES objectAtIndex:indexPath.row];
        
        [self DicitonaryFormation];
        [self convertToJson:dictonaryToPost];
        //[self convertToJson(dictonaryToPost)];

        NSLog(@"%@",userLocation);
        donorsDisplayViewController1.donorsArray = arrayOfDonars;
        donorsDisplayViewController1.userLocation = userLocation;
      [self.navigationController  pushViewController:donorsDisplayViewController1 animated:YES];
        
    }
    else if(tableView == tableViewForSettings){
        switch (indexPath.row) {
            case 0:{
                [tableViewForSettings removeFromSuperview];
                RegistrationPageViewController *registration = [storyboard instantiateViewControllerWithIdentifier:@"RegistrationPageViewController"];
                NSLog(@"%@",self.navigationController);
                registration.registerOrUpdate = YES;
                registration.userLocation = userLocation;
                [self.navigationController pushViewController:registration animated:YES];
            }
                
                break;
            case 1:{
                
                NSLog(@"ON setings screen");
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark : API Functions

-(void) DicitonaryFormation{

   dictonaryToPost = [[NSMutableDictionary alloc]init];
    [dictonaryToPost setObject:bloodSelected forKey:BLOODTYPE];
    [dictonaryToPost setObject:[[NSNumber numberWithFloat:userLocation.coordinate.latitude] stringValue]  forKey:LATTITUDE];

     [dictonaryToPost setObject:[[NSNumber numberWithFloat:userLocation.coordinate.longitude] stringValue]  forKey:LONGITUDE];
  
    //return dictonaryToPost;
}


-(void)convertToJson:(NSDictionary *)dicitonaryToConvert {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicitonaryToConvert
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSLog(@"%@",jsonData);
    NSString* aStr;
    aStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",aStr);
    
}


@end



