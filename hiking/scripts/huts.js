module.exports = {
    update: function(MongoClient, mongoServerUrl) {
        MongoClient.connect(mongoServerUrl, function(err, db) {
            for (var i = 0; i < hutQueryUrls.length; i++) {
                var hut = hutQueryUrls[i];
                var writeResult = db.collection('huts').update({
                    nameZh: hut.nameZh
                }, {
                    name: hut.name,
                    nameZh: hut.nameZh,
                    url: hut.url,
                    admin: hut.admin
                }, {
                    upsert: true
                });
            };
        });
    }
};

// huts' info
var hutQueryUrls = [{
    name: 'Qika Hut',
    nameZh: '七卡山莊',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=13',
    admin: '雪霸國家公園'
}, {
    name: 'Qika Campground',
    nameZh: '七卡營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=8',
    admin: '雪霸國家公園'
}, {
    name: 'Sancha Campground',
    nameZh: '三叉營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=37',
    admin: '雪霸國家公園'
}, {
    name: 'Saliujiu Hut',
    nameZh: '三六九山莊',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=4',
    admin: '雪霸國家公園'
}, {
    name: 'Carrying Capacity of Daba Line',
    nameZh: '大霸線承載量',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=66',
    admin: '雪霸國家公園'
}, {
    name: 'Taoshan Hut',
    nameZh: '桃山山屋',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=38',
    admin: '雪霸國家公園'
}, {
    name: 'Taoshan Campground',
    nameZh: '桃山營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=45',
    admin: '雪霸國家公園'
}, {
    name: 'Sumida Shelter',
    nameZh: '素密達山屋',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=31',
    admin: '雪霸國家公園'
}, {
    name: 'Mayang Mountain Campground',
    nameZh: '馬洋山前營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=87',
    admin: '雪霸國家公園'
}, {
    name: 'Mayang Pond Campground',
    nameZh: '馬洋池營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=90',
    admin: '雪霸國家公園'
}, {
    name: 'Syuebei Shelter',
    nameZh: '雪北山屋',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=29',
    admin: '雪霸國家公園'
}, {
    name: 'Xinda Hut',
    nameZh: '新達山屋',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=35',
    admin: '雪霸國家公園'
}, {
    name: 'Xinda Campground',
    nameZh: '新達營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=44',
    admin: '雪霸國家公園'
}, {
    name: 'Cuei Pond Shelter',
    nameZh: '翠池山屋',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=11',
    admin: '雪霸國家公園'
}, {
    name: 'Cuei Pond Campground',
    nameZh: '翠池營地',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=43',
    admin: '雪霸國家公園'
}, {
    name: 'Banan Hut',
    nameZh: '霸南山屋',
    url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=91',
    admin: '雪霸國家公園'
}, {
    name: 'Heishuitang Cabin',
    nameZh: '黑水塘山屋',
    url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=1',
    admin: '太魯閣國家公園'
}, {
    name: 'Cheng Gong Cabin',
    nameZh: '成功山屋',
    url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=2',
    admin: '太魯閣國家公園'
}, {
    name: 'Cheng Gong Cabin No.2',
    nameZh: '成功二號堡',
    url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=3',
    admin: '太魯閣國家公園'
}, {
    name: 'Qilai Cabin',
    nameZh: '奇萊山屋',
    url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=4',
    admin: '太魯閣國家公園'
}, {
    name: 'Yuleng Cabin',
    nameZh: '雲稜山屋',
    url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=5',
    admin: '太魯閣國家公園'
}, {
    name: 'Shenmazhen Cabin',
    nameZh: '審馬陣山屋',
    url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=7',
    admin: '太魯閣國家公園'
}, {
    name: 'Nanhu Cabin',
    nameZh: '南湖山屋',
    url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=20',
    admin: '太魯閣國家公園'
}];