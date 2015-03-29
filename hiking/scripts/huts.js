//
var hutQueryUrls = [{
    name: 'Qika Hut',
    nameZh: '七卡山莊',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=13'
}, {
    name: 'Qika Campground',
    nameZh: '七卡營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=8'
}, {
    name: 'Sancha Campground',
    nameZh: '三叉營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=37'
}, {
    name: 'Saliujiu Hut',
    nameZh: '三六九山莊',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=4'
}, {
    name: 'Carrying Capacity of Daba Line',
    nameZh: '大霸線承載量',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=66'
}, {
    name: 'Taoshan Hut',
    nameZh: '桃山山屋',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=38'
}, {
    name: 'Taoshan Campground',
    nameZh: '桃山營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=45'
}, {
    name: 'Sumida Shelter',
    nameZh: '素密達山屋',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=31'
}, {
    name: 'Mayang Mountain Campground',
    nameZh: '馬洋山前營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=87'
}, {
    name: 'Mayang Pond Campground',
    nameZh: '馬洋池營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=90'
}, {
    name: 'Syuebei Shelter',
    nameZh: '雪北山屋',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=29'
}, {
    name: 'Xinda Hut',
    nameZh: '新達山屋',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=35'
}, {
    name: 'Xinda Campground',
    nameZh: '新達營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=44'
}, {
    name: 'Cuei Pond Shelter',
    nameZh: '翠池山屋',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=11'
}, {
    name: 'Cuei Pond Campground',
    nameZh: '翠池營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=43'
}, {
    name: 'Banan Hut',
    nameZh: '霸南山屋',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=91'
}];

MongoClient.connect(mongoServerUrl, function(err, db) {
    db.collection('huts').insertMany(hutQueryUrls, function(err, r) {
        db.close();
    });
});