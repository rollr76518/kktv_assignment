
Dear candidate,

Please use Xcode 9 to write this assignmnet.You can use swift 3.2/4.0 whatever you like.

It's better if you commit as detail as possible.
You can use any 3rd party library if you need.
You can find some resource you may need in APISample.

If you have any question , you can mail to ios.dev@kktv.me

Please put your answer in a public repo, after you finish. Please mail to hr@kkstream.com.tw also attach repo link.

------------
This assignment include following section:

# Model
variable definition already comment in class
finish init function in AppVersion

# API
please fill the rest part in ServiceStatusAPI, 

`func fetchServiceStatus( callback:@escaping StatusAPICompletion)`

# Model and API Handler
please fill the rest part in ServiceStatusHandler
`func start()`
1. MUST cover all ServiceStatusDelegate function
2. MUST retry if retryCount not reach retryMax

# Unit Test 
please write unit test for Handler and Model

put test code in `ServiceStatusHandlerTest` and `ModelTest` files

write as many tests as you can
