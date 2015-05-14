async = require 'async'
MongoClient = require('mongodb').MongoClient
mongoServerUrl = 'mongodb://yes:yes@ds035280.mongolab.com:35280/hiking'
collectionName = 'huts'

MongoClient.connect(mongoServerUrl, (err, db)->
	async.series(
		dropCollection: (callback)->
			db.collection(collectionName).drop((err, result) -> callback(err, result))
		createCollection: (callback)->
			db.createCollection(collectionName, (err, result) -> callback(err, result))
		insertDocuments: (callback)->
			db.collection(collectionName).insert(hutQueryUrls, (err, result) -> callback(err, result))
	, (err, results) ->
		console.log 'done'
		process.exit()
	)
)

# huts' info
hutQueryUrls = [
	name: 'Qika Hut'
	nameZh: '七卡山莊'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=13'
	admin: '雪霸國家公園'
	capacity: '130'
	isApplicable: true
,
	name: 'Qika Campground'
	nameZh: '七卡營地'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=8'
	admin: '雪霸國家公園'
	capacity: '10'
	isApplicable: true
,
	name: 'Sancha Campground'
	nameZh: '三叉營地'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=37'
	admin: '雪霸國家公園'
	capacity: '6'
	isApplicable: true
,
	name: 'Saliujiu Hut'
	nameZh: '三六九山莊'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=4'
	admin: '雪霸國家公園'
	capacity: '106'
	isApplicable: true
,
	name: 'Carrying Capacity of Daba Line'
	nameZh: '大霸線承載量'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=66'
	admin: '雪霸國家公園'
	capacity: '130'
	isApplicable: false;
,
	name: 'Huoshihshansia Campground'
	nameZh: '火石山下營地'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=80'
	admin: '雪霸國家公園'
	capacity: '6'
	isApplicable: false;    
,
	name: 'Wanmeigu Campground'
	nameZh: '完美谷營地'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=24'
	admin: '雪霸國家公園'
	capacity: '6'
	isApplicable: true    
,
	name: 'Youpolan Campground'
	nameZh: '油婆蘭營地'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=17'
	admin: '雪霸國家公園'
	capacity: '10'
	isApplicable: true    
,
	name: 'Taoshan Hut'
	nameZh: '桃山山屋'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=38'
	admin: '雪霸國家公園'
	capacity: '19'
	isApplicable: true
,
	name: 'Taoshan Campground'
	nameZh: '桃山營地'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=45'
	admin: '雪霸國家公園'
	capacity: '2'
	isApplicable: true
,
	name: 'Sumida Shelter'
	nameZh: '素密達山屋'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=31'
	admin: '雪霸國家公園'
	capacity: '24'
	isApplicable: true
,
	name: 'Mayang Mountain Campground'
	nameZh: '馬洋山前營地'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=87'
	admin: '雪霸國家公園'
	capacity: '999'
	isApplicable: true
,
	name: 'Mayang Pond Campground'
	nameZh: '馬洋池營地'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=90'
	admin: '雪霸國家公園'
	capacity: '8'
	isApplicable: true
,
	name: 'Former Site of Syueshan Cabin Campground'
	nameZh: '雪山山莊舊址營地'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=48'
	admin: '雪霸國家公園'
	capacity: '6'
	isApplicable: true
,
	name: 'Syuebei Shelter'
	nameZh: '雪北山屋'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=29'
	admin: '雪霸國家公園'
	capacity: '25'
	isApplicable: true
,
	name: 'Xinda Hut'
	nameZh: '新達山屋'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=35'
	admin: '雪霸國家公園'
	capacity: '34'
	isApplicable: true
,
	name: 'Xinda Campground'
	nameZh: '新達營地'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=44'
	admin: '雪霸國家公園'
	capacity: '6'
	isApplicable: true
,
	name: 'Cuei Pond Shelter'
	nameZh: '翠池山屋'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=11'
	admin: '雪霸國家公園'
	capacity: '12'
	isApplicable: true
,
	name: 'Cuei Pond Campground'
	nameZh: '翠池營地'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=43'
	admin: '雪霸國家公園'
	capacity: '5'
	isApplicable: true
,
	name: 'Piaodan Hut Campground'
	nameZh: '瓢簞營地'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=49'
	admin: '雪霸國家公園'
	capacity: '8'
	isApplicable: true
,
	name: 'Sailiangjiou Campground'
	nameZh: '賽良久營地'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=50'
	admin: '雪霸國家公園'
	capacity: '4'
	isApplicable: true    
,
	name: 'Banan Hut'
	nameZh: '霸南山屋'
	url: 'https://apply.spnp.gov.tw/BookingInfo.php?MonthInfo=1&HouseID=91'
	admin: '雪霸國家公園'
	capacity: '15'
	isApplicable: true
,
	name: 'Heishuitang Cabin'
	nameZh: '黑水塘山屋'
	url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=1'
	admin: '太魯閣國家公園'
	capacity: '10'
	isApplicable: true
,
	name: 'Cheng Gong Cabin'
	nameZh: '成功山屋'
	url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=2'
	admin: '太魯閣國家公園'
	capacity: '34'
	isApplicable: true
,
	name: 'Cheng Gong Cabin No.2'
	nameZh: '成功二號堡'
	url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=3'
	admin: '太魯閣國家公園'
	capacity: '10'
	isApplicable: true
,
	name: 'Qilai Cabin'
	nameZh: '奇萊山屋'
	url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=4'
	admin: '太魯閣國家公園'
	capacity: '8'
	isApplicable: true
,
	name: 'Yuleng Cabin'
	nameZh: '雲稜山屋'
	url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=5'
	admin: '太魯閣國家公園'
	capacity: '55'
	isApplicable: true
,
	name: 'Shenmazhen Cabin'
	nameZh: '審馬陣山屋'
	url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=7'
	admin: '太魯閣國家公園'
	capacity: '12'
	isApplicable: true
,
	name: 'Nanhu Cabin'
	nameZh: '南湖山屋'
	url: 'http://permits2.taroko.gov.tw/2013_taroko/chk_3H.php?Deal=Loading&code=UTF8&chkvalue=20'
	admin: '太魯閣國家公園'
	capacity: '40'
	isApplicable: true
,
	name: ''
	nameZh: '檜谷山莊'
	url: 'http://recreation.forest.gov.tw/askformonhouse/AskForPaperAddNew.aspx?mode=0&AskSID=&houseid=C'
	admin: '台灣山林悠遊網'
	capacity: '42'
	isApplicable: true
,
	name: ''
	nameZh: '向陽山屋'
	url: 'http://recreation.forest.gov.tw/askformonhouse/AskForPaperAddNew.aspx?mode=0&AskSID=&houseid=A'
	admin: '台灣山林悠遊網'
	capacity: '70'
	isApplicable: true
,
	name: ''
	nameZh: '嘉明湖山屋'
	url: 'http://recreation.forest.gov.tw/askformonhouse/AskForPaperAddNew.aspx?mode=0&AskSID=&houseid=B'
	admin: '台灣山林悠遊網'
	capacity: '70'
	isApplicable: true
,
	name: 'Paiyun Lodge'
	nameZh: '排雲山莊'
	url: 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003'
	admin: '玉山國家公園'
	capacity: '92'
	isApplicable: true	
,
	name: 'Yuanfong Cabin / Campground'
	nameZh: '圓峰山屋/營地'
	url: 'https://mountain.ysnp.gov.tw/chinese/LocationAppIndex.aspx?pg=01&w=1&n=1003'
	admin: '玉山國家公園'
	capacity: '15+9'
	isApplicable: true
,
	name: 'Tianchi Hill'
	nameZh: '天池山莊'
	url: 'http://tconline.forest.gov.tw/order/'
	admin: '南投林區管理處'
	capacity: '88'
	isApplicable: true	
]
