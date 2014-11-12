//
//  ViewController.swift
//  Swift Weather
//
//  Created by pang on 14-11-2.
//  Copyright (c) 2014年 庞浩斌. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate{
    
    let locationManager:CLLocationManager = CLLocationManager()
    var timer:NSTimer?
    var dataArr = NSMutableArray()
    var desArrays = NSMutableArray()
    
    @IBOutlet weak var backImagView: UIImageView!
    @IBOutlet var loadingIndicator : UIActivityIndicatorView! = nil
    @IBOutlet var icon : UIImageView!
    @IBOutlet var temperature : UILabel!
    @IBOutlet var loading : UILabel!
    @IBOutlet var location : UILabel!
    
    @IBOutlet weak var weekWeather: UITableView!
//
    
    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet weak var pm25: UILabel!
    
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var wind: UILabel!
    
    @IBOutlet weak var detailTextView: UITextView!
    //穿衣
    @IBAction func clothesClick(sender: AnyObject) {
        self.detailTextView.text = desArrays.objectAtIndex(0)as String
    }
    //洗车
    @IBAction func washClick(sender: AnyObject) {
        self.detailTextView.text = desArrays.objectAtIndex(1)as String
    }
    //旅游
    @IBAction func tourClick(sender: AnyObject) {
        self.detailTextView.text = desArrays.objectAtIndex(2)as String
    }
    //感冒
    @IBAction func coldClick(sender: AnyObject) {
        self.detailTextView.text = desArrays.objectAtIndex(3)as String
    }
    //运动
    @IBAction func sportClick(sender: AnyObject) {
        self.detailTextView.text = desArrays.objectAtIndex(4)as String
    }
    //紫外线
    @IBAction func rayClick(sender: AnyObject) {
        self.detailTextView.text = desArrays.objectAtIndex(5)as String
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.loadingIndicator.startAnimating()
        self.backImagView.addSubview(self.icon);
        self.backImagView.addSubview(self.temperature);
        self.backImagView.addSubview(self.loading);
        self.backImagView.addSubview(self.location);
        
        
        weekWeather?.delegate = self;
        weekWeather?.dataSource = self;
        weekWeather?.transform = CGAffineTransformMakeRotation(-3.14/2);
        self.view.addSubview(self.weekWeather);
        
        self.view.userInteractionEnabled = true;
        
        
//        let background = UIImage(named: "backImage.tiff")
//        self.view.backgroundColor = UIColor(patternImage: background)
        
//        self.backImagView = UIImageView(image: UIImage(named: "backImage.tiff"));
//        self.backImagView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
        
        
//点击手势
//        let singleFingerTap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
//        self.view.addGestureRecognizer(singleFingerTap)
        
        if ( ios8() ) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()

//         timer = NSTimer(fireDate: NSDate.distantPast() as NSDate, interval: 1, target: self, selector: "speechFinishThread", userInfo: nil, repeats: true);
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:Selector("speechFinishThread"), userInfo: nil, repeats: true)


    }
    func speechFinishThread(){
        println("hello speechFinishThread")
        locationManager.startUpdatingLocation()
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let manager = AFHTTPRequestOperationManager()
        let url = "http://api.openweathermap.org/data/2.5/weather"
        println(url)
        
        let params = ["lat":latitude, "lon":longitude, "cnt":0]
        println(params)
        
        manager.GET(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                println("JSON: " + responseObject.description!)
                
                self.updateUISuccess(responseObject as NSDictionary!)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                
                self.loading.text = "Internet appears down!"
        })
    }
    /**
    更新今天天气
    
    :param: jsonResult <#jsonResult description#>
    */
    func updateTodayWeatherInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let manager = AFHTTPRequestOperationManager()
//        let url = "http://api.openweathermap.org/data/2.5/weather"
        let url = "http://api.map.baidu.com/telematics/v3/weather?&output=json&ak=3a88f7aaa021e1d595f46b28889dde86"
        println(url)
        
        let params = ["location":"\(longitude),\(latitude)" ]
//        let params = ["location":"北京" ]
        println(params)
        
        manager.GET(url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                println("JSON: " + responseObject.description!)
                
                self.updateTodayUISuccess(responseObject as NSDictionary!)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                
                self.loading.text = "Internet appears down!"
        })
    }
    func updateTodayUISuccess(jsonResult: NSDictionary!) {
        
        self.loading.text = nil
        self.loadingIndicator.hidden = true
        self.loadingIndicator.stopAnimating()
        
        if let results = (jsonResult["results"]? as? NSArray){
            
            for element in results{
                
                
                if let currentCity = (element as NSDictionary)["currentCity"]as? String {
                    println("currentCity ======\(currentCity)")
                    self.currentCity.text = currentCity
                }
                if let indexArr = (element as NSDictionary)["index"]as? NSArray {
                    desArrays.removeAllObjects()
                    for desElement in indexArr {
                        if let des = (desElement as NSDictionary)["des"]as? String{
                            println("des \(des)")
                            desArrays.addObject(des)
                        }
                    }
                    self.detailTextView.text = desArrays.objectAtIndex(0)as String
                }
                
                if let pm25_data = (element as NSDictionary)["pm25"]as? String {
                    println("pm25_data ======\(pm25_data)")
                    let pmInt:Int = pm25_data.toInt()!
                    self.pm25.textColor = UIColor.blackColor()
                    if pmInt >= 0 && pmInt <= 50 {
                        self.pm25.backgroundColor = UIColor.greenColor()
                        self.pm25.text = "优 \(pmInt)"
                        
                    }else if pmInt >= 51 && pmInt <= 100 {
                        self.pm25.backgroundColor = UIColor.yellowColor()
                        self.pm25.text = "良 \(pm25_data)"
                        
                    }else if pmInt >= 101 && pmInt <= 150 {
                        self.pm25.backgroundColor = UIColor.orangeColor()
                        self.pm25.text = "轻度污染 \(pmInt)"
                        
                    }else if pmInt >= 151 && pmInt <= 200 {
                        self.pm25.backgroundColor = UIColor.redColor()
                        self.pm25.text = "中度污染 \(pmInt)"
                        
                    }else if pmInt >= 201 && pmInt <= 300 {
                        self.pm25.backgroundColor = UIColor.purpleColor()
                        self.pm25.text = "重度污染 \(pmInt)"
                        
                    }else{
                        self.pm25.backgroundColor = UIColor.brownColor()
                        self.pm25.text = "严重污染 \(pmInt)"
                    }
                    
                    
                }
                 if let weather_data = (element as NSDictionary)["weather_data"]as? NSArray {
                    var icount:Int = 0
                    dataArr.removeAllObjects()
                    for weather_dataElement in weather_data{
                        var weathermodel: WeatherModel = WeatherModel();
                        if icount == 0{
                            self.location.text = (weather_dataElement as NSDictionary)["date"]as? String
                            self.weather.text = (weather_dataElement as NSDictionary)["weather"]as? String

                            self.wind.text = (weather_dataElement as NSDictionary)["wind"]as? String
                            self.temperature.text = (weather_dataElement as NSDictionary)["temperature"]as? String
                            weathermodel.date = "今天"

                        }else {
                            if let weather_dataDict = (weather_dataElement as NSDictionary)["date"]as? String{
                                println("weather_dataDict ======\(weather_dataDict)")
                                weathermodel.date = weather_dataDict
                            }
                        }
                        
                        if let temperature = (weather_dataElement as NSDictionary)["temperature"]as? String{
                            println("temperature ======\(temperature)")
                            weathermodel.temp = temperature
                        }
                        if let wind = (weather_dataElement as NSDictionary)["wind"]as? String{
                            println("wind ======\(wind)")
                            weathermodel.winddeg = wind
                        }
                        if let weather = (weather_dataElement as NSDictionary)["weather"]as? String{
                            println("weather ======\(weather)")
                            weathermodel.iconId = weather
                        }
                        icount++
                        dataArr.addObject(weathermodel);
                    }
                   
                }
            }
           
            
        }
        //更新数据
        weekWeather.reloadData();
//        self.loading.text = "Weather info is not available!"

    }
    
    func updateUISuccess(jsonResult: NSDictionary!) {
        self.loading.text = nil
        self.loadingIndicator.hidden = true
        self.loadingIndicator.stopAnimating()
        
        if let tempResult = ((jsonResult["main"]? as NSDictionary)["temp"] as? Double) {
            
            // If we can get the temperature from JSON correctly, we assume the rest of JSON is correct.
            var temperature: Double
            if let sys = (jsonResult["sys"]? as? NSDictionary) {
                
                
                if let weather = jsonResult["weather"]? as? NSArray {
                    var condition = (weather[0] as NSDictionary)["id"] as Int
                    var sunrise = sys["sunrise"] as Double
                    var sunset = sys["sunset"] as Double
                    
                    var nightTime = false
                    var now = NSDate().timeIntervalSince1970
                    // println(nowAsLong)
                    
                    if (now < sunrise || now > sunset) {
                        nightTime = true
                    }
                    self.updateWeatherIcon(condition, nightTime: nightTime)
                    return
                }
            }
        }
        self.loading.text = "Weather info is not available!"
    }
    
    // Converts a Weather Condition into one of our icons.
    // Refer to: http://bugs.openweathermap.org/projects/api/wiki/Weather_Condition_Codes
    func updateWeatherIcon(condition: Int, nightTime: Bool) {
        // Thunderstorm
        if (condition < 300) {
            if nightTime {
                self.icon.image = UIImage(named: "tstorm1_night")
            } else {
                self.icon.image = UIImage(named: "tstorm1")
            }
        }
        // Drizzle
        else if (condition < 500) {
            self.icon.image = UIImage(named: "light_rain")
        }
        // Rain / Freezing rain / Shower rain
        else if (condition < 600) {
            self.icon.image = UIImage(named: "shower3")
        }
        // Snow
        else if (condition < 700) {
            self.icon.image = UIImage(named: "snow4")
        }
        // Fog / Mist / Haze / etc.
        else if (condition < 771) {
            if nightTime {
                self.icon.image = UIImage(named: "fog_night")
            } else {
                self.icon.image = UIImage(named: "fog")
            }
        }
        // Tornado / Squalls
        else if (condition < 800) {
            self.icon.image = UIImage(named: "tstorm3")
        }
        // Sky is clear
        else if (condition == 800) {
            if (nightTime){
                self.icon.image = UIImage(named: "sunny_night") // sunny night?
            }
            else {
                self.icon.image = UIImage(named: "sunny")
            }
        }
        // few / scattered / broken clouds
        else if (condition < 804) {
            if (nightTime){
                self.icon.image = UIImage(named: "cloudy2_night")
            }
            else{
                self.icon.image = UIImage(named: "cloudy2")
            }
        }
        // overcast clouds
        else if (condition == 804) {
            self.icon.image = UIImage(named: "overcast")
        }
        // Extreme
        else if ((condition >= 900 && condition < 903) || (condition > 904 && condition < 1000)) {
            self.icon.image = UIImage(named: "tstorm3")
        }
        // Cold
        else if (condition == 903) {
            self.icon.image = UIImage(named: "snow5")
        }
        // Hot
        else if (condition == 904) {
            self.icon.image = UIImage(named: "sunny")
        }
        // Weather condition is not available
        else {
            self.icon.image = UIImage(named: "dunno")
        }
    }
    
    /*
    iOS 8 Utility
    */
    func ios8() -> Bool {
        if ( NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 ) {
            return false
        } else {
            return true
        }
    }
    
    //CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        println("位置更新 ")
        var location:CLLocation = locations[locations.count-1] as CLLocation
        
        if (location.horizontalAccuracy > 0) {
            self.locationManager.stopUpdatingLocation()
            println(location.coordinate)

//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//                
//                //这里写需要大量时间的代码
//                self.updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
//
//                    println("GCD thread running.")
//
//                
//              
//                
//                dispatch_async(dispatch_get_main_queue(), {
//                    
//                    //这里返回主线程，写需要主线程执行的代码
//                    println("这里返回主线程，写需要主线程执行的代码")  
//                })  
//            })
//            updateTodayWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            
            
            var t1:dispatch_queue_t = dispatch_queue_create("1", nil);
            
            var t2:dispatch_queue_t = dispatch_queue_create("2", nil);
            
            dispatch_async(t1, {
                println("GCD thread1 running.")
                //这里写需要大量时间的代码
                self.updateWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
                
                
                
                }); 
            
            dispatch_async(t2, {
                println("GCD thread2 running.")
                self.updateTodayWeatherInfo(location.coordinate.latitude, longitude: location.coordinate.longitude)
                
                
                });
        }
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
        self.loading.text = "Can't get your location!"
    }
    //uitabview 协议
    //协议
    func  tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count;
       
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellid = "my cell id";
        var cell = tableView.dequeueReusableCellWithIdentifier(cellid) as? WeatherTableViewCell;
        if(cell == nil){

            cell = NSBundle.mainBundle().loadNibNamed("WeatherTableViewCell", owner: self, options: nil)[0] as? WeatherTableViewCell;
        }
        cell?.contentView.transform = CGAffineTransformMakeRotation(3.14 / 2);
        
        let img = UIImage(named: "bgWidget@2x");
        let imagV = UIImageView(frame:CGRectMake(0, 0, 320, 100))
        imagV.image = img
        cell?.backgroundView = imagV
        
        if(dataArr.count != 0){
            
//            cell?.weatherDesp.font = UIFont.boldSystemFontOfSize(15)
//            cell?.weatherDesp.text = dataArr.objectAtIndex(indexPath.row).descrip
            
            cell?.date.font = UIFont.boldSystemFontOfSize(20)
            cell?.date.font = UIFont(name: "Helvetica Neue Light", size: 20)
            cell?.date.text = dataArr.objectAtIndex(indexPath.row).date
            println("图片\(dataArr.objectAtIndex(indexPath.row).iconId)")
            
            let img = UIImage(named: (dataArr.objectAtIndex(indexPath.row).iconId)!!);
            cell?.weatherIcon.image = img
            
            cell?.temp.font = UIFont.boldSystemFontOfSize(12)
            
            cell?.temp.text = dataArr.objectAtIndex(indexPath.row).temp!!

            cell?.wind.text = dataArr.objectAtIndex(indexPath.row).winddeg!!
            
        }

        
        return cell!;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("select \(indexPath.row)");
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
