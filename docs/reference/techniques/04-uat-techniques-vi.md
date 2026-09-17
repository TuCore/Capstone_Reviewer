# Cac ky thuat cho qua trinh test chap nhan UAT

> Converted from original reference file. Formatting simplified.

## Page 1

/
Home 
Các kỹ thuật quan trọng dùng cho quá trình test chấp nhận (UAT) - Ph ầ n 1
 Facebook  Twitter  Google+
Các kỹ thuật quan trọng dùng cho quá trình test chấp nhận (UAT) - Ph ầ n 1

HTTPS://VIBLO.ASIA/P/CAC-KY-THUAT-QUAN-TRONG-DUNG-CHO-QUA-TRINH-TEST- C...
Bài viết liên quan
10 công cụ kiểm thử tự động nổi bật trong năm 2019 ( phần 1)
kiểm thử hiệu năng chuyên nghiệp với jmeter
quản lý khiếm khuyết phần mềm
nâng cao, phát triển sự nghiệp của bạn trong kiểm thử phần mềm qa’s roles vs goals: how to balance both to achieve your goals
1. Test ch ấ p nh ậ n người dùng (UAT - User Acceptance Test) là gì?
QA
T PHAN MINH HUỆ
 Đầu mục bài viết 
JAVASCRIPT RUBY PHP IOS ANDROID SWIFT RAILS LARAVEL REACTJS RUBY ON RAILS 
JAVASCRIPT RUBY PHP IOS ANDROID SWIFT RAILS LARAVEL REACTJS RUBY ON RAILS 

## Page 2

/
Những người sở hữu s ả n ph ẩ m (PO - Product Owners) và những đơn v ị
kinh doanh nhìn chung làm vi ệ c dựa trên những yêu c ầ u và t ậ
p trung vào chúng. Do đó h ọ s ẽ sử d ụ ng những k ỹ thu ậ t test dựa trên những yêu c ầ
u và dựa trên những ho ạ t đ ộ ng trong quá trình test ch ấ p nh ậ
n phía người dùng. Bởi vì chúng ta là những tester, chúng ta c ũ ng có th ể sử d ụ ng những k ỹ thu ậ
t này trong quá trình test. Bài vi ế t này s ẽ đi gi ả i thích m ộ t vài k ỹ thu ậ t quan tr ọ
ng nh ấ t trong s ố
đó. Đ ầ u tiên chúng ta s ẽ đi tr ả lời câu h ỏ i quá trình test ch ấ p nh ậ
n người dùng (UAT) là gì. Theo phương thức Agile, nó là m ộ t ho ạ t đ ộ
ng test được thực thi bởi những người sở hữu s ả n ph ẩ m nói chung sau khi quá trình phát tri ể
n và test ph ầ n m ề
m hoàn thành. Trong những quá trình waterfall và V-Model, những bài test này nhìn chung được thực hi ệ n bởi những nhà phân tích ho ặ
c những đơn v ị kinh doanh. M ụ c đích c ủ a UAT là xác đ ị nh xem những yêu c ầ
u c ủ a người dùng cho những công vi ệ c được yêu c ầ u có được thực hi ệ
n chính xác hay không đ ể l ấ y chứng nh ậ n cho toàn b ộ quá trình phát tri ể
n và test ph ầ n m ề m đã được thực hi ệ
n. M ộ t m ẫ u cho những đ ầ u vào và đ ầ u ra cho quá trình test ch ấ p nh ậ
n người dùng được tóm tắt trong b ả ng bên dưới
 Đầu mục bài viết 
JAVASCRIPT RUBY PHP IOS ANDROID SWIFT RAILS LARAVEL REACTJS RUBY ON RAILS 

## Page 3

/
2. Các k ỹ thu ậ t test quan tr ọ ng liên quan đ ế n quá trình UAT
Trong bài vi ế t s ẽ đi vào phân tích 8 k ỹ thu ậ t quan tr ọ ng nh ấ t liên quan đ ế
n quá trình UAT bao g ồ m:
User Story Testing (AGILE) - Test AGILE Use Case Testing - Test theo trường hợp sử d ụ
ng
Checklist Based Testing - Test dựa trên checklist Exploratory Testing - Test khai thác, tìm ki ế
m. Experienced Based Testing - Test dựa trên kinh nghi ệ m.
 Đầu mục bài viết 
JAVASCRIPT RUBY PHP IOS ANDROID SWIFT RAILS LARAVEL REACTJS RUBY ON RAILS 

## Page 4

/
User Journey Test - Test k ị ch b ả
n người dùng Risk-Based Testing - Test dựa trên các r ủ
i ro. Heuristic Risk-Based Testing by James Bach - Test dựa trên r ủ
i ro Heuristic được đưa ra bởi James Bach
2.1. User Story Testing (AGILE)
M ộ t câu chuy ệ n người dùng (user story) có th ể được mô t ả như m ộ t đ ặ c đi ể
m được yêu c ầ u cái mà được phát tri ể n trong ph ầ n m ề m xu ấ t phát từ quan đi ể
m, cách nhìn c ủ a người dùng cu ố i trong chu k ỳ phát tri ể n ph ầ n m ề
m agile. Trong m ộ t câu chuy ệ n người dùng, chúng ta ph ả i xác đ ị nh được yêu c ầ
u là gì, nguyên nhân t ạ i sao có yêu c ầ u đó và ai là người đã đưa ra yêu c ầ
u. Đ ị nh ngh ĩ a v ề sự hoàn thành (Definition of Done - DOD) đ ị nh ngh ĩ
a tiêu chu ẩ n v ề sự hoàn thành ví d ụ như mã ngu ồ n đã hoàn thành, vi ệ c test đơn v ị
(unit test) đã hoàn thành, t ấ t c ả vi ệ
c test đã hoàn thành, quá trình UAT đã hoàn thành, … và những người phát tri ể n, các tester, những người sở hữu s ả
n ph ẩ m s ẽ có trách nhi ệ m thực hi ệ n các DOD đã được đ ặ
t ra. Những ch ỉ tiêu đ ể đánh giá tính ch ấ p nh ậ n được c ủ a ph ầ n m ề m c ũ
ng nên được di ễ n đ ạ t rõ ràng bởi người sở hữu s ả n ph ầ m (POs). Team phát tri ể n c ũ
ng có th ể giúp PO làm đi ề u này. Ít nh ấ t m ộ t k ị ch b ả n test cho m ỗ
i tiêu chí đánh giá tính ch ấ p nh ậ n được c ủ a s ả n ph ẩ m nên được chu ẩ n b ị đ ể test m ộ
t câu truy ệ n người dùng (user story) và các tiêu chí mang tính ch ấ p nh ậ n này ph ả
i được test r ấ t c ẩ n th ậ
n. Đ ầ u vào và đ ầ u ra c ầ n được đ ị nh ngh ĩ a trước khi bắt đ ầ
u quá trình test, bên dưới là ví d ụ :
 Đầu mục bài viết 
JAVASCRIPT RUBY PHP IOS ANDROID SWIFT RAILS LARAVEL REACTJS RUBY ON RAILS 

## Page 5

/
Bên dưới chúng ta cùng phân tích m ộ t câu chuy ệ n người dùng m ẫ
u: Như m ộ t người sở hữu s ả n ph ẩ m (Người dùng), đ ể qu ả ng bá vi ệ c kariyer.net
hưởng ứng cu ộ c v ậ n đ ộ ng, (Nguyên nhân c ủ a yêu c ầ u), tôi mu ố n có m ộ
t banner qu ả ng cáo được thêm vào ph ầ n banner đ ầ u trên trang ch ủ c ủ a
kariyer.net
. Những nguy cơ:
T ố c đ ộ trang ch ủ có th ể gi ả
m M ộ t l ỗ i trong ph ầ n ả nh đ ộ ng c ủ a banner có th ể ả nh hưởng đ ế n sự xu ấ t hi ệ
n c ủ a trang ch ủ
. Vi ệ c xóa cookie có th ể làm cho banner liên t ụ c hi ệ n ở phía người dùng.
 Đầu mục bài viết 
JAVASCRIPT RUBY PHP IOS ANDROID SWIFT RAILS LARAVEL REACTJS RUBY ON RAILS 

## Page 6

/
Chức năng đóng ả nh banner là quan tr ọ ng. Nó ph ả i luôn làm vi ệ c đúng
Phân tích chuyên sâu: Chức năng t ả i banner có th ể ả nh hưởng đ ế
n Admin
panel. Đ ị nh ngh ĩ a những sự hoàn thành (DOD):
Code được vi ế
t xong
Code được review xong Những bài test đơn v ị (Unit Test) được thực hi ệ
n xong. Quá trình UAT được thực hi ệ n xong.
Các ch ỉ đánh giá tính ch ấ p nh ậ n:
Khi trang web được mở, top banner được hi ể n th ị
với kích thước 200x200 trong 8 giây, sau đó thu v ề
kích thước 60x60. Khi người dùng kích vào banner, trang web nên chuy ể n đ ế
n trang chào mừng. N ế u người dùng vào trang web 4 l ầ
n trên cùng 1 máy tính, giá trình bên trong cookie c ủ a banner nên là 4 ho ặ c hơn, khi đó bannner không nên được hi ể n th ị
. Góc trên bên ph ả i c ủ a banner ph ả i có m ộ t hình đ ể đóng banner l ạ
i và banner s ẽ b ị
đóng khi kích vào hình đó. N ế u banner đã được tắt bởi người dùng, nó không nên được hi ể n th ị l ạ i.
Bên dưới là m ẫ u test case theo các ch ỉ tiêu ch ấ p nh ậ n được mô t ả bên trên:  Đầu mục bài viết 
JAVASCRIPT RUBY PHP IOS ANDROID SWIFT RAILS LARAVEL REACTJS RUBY ON RAILS 

## Page 7

/
2.2. Use Case Testing
M ộ t trường hợp sử d ụ ng (Use Case) đ ị nh ngh ĩ a những ho ạ t đ ộ ng thực thi c ủ
a người dùng trong h ệ th ố ng đ ể thực hi ệ n m ộ t m ụ c đích nh ấ t đ ị
nh. Những yêu c ầ u chức năng c ủ a h ệ th ố ng c ủ a th ể được đ ị nh ngh ĩ a và qu ả n lý sử d ụ
ng những use case. Theo cách này, m ộ t danh sách những công vi ệ c mong mu ố
n được xác đ ị nh. Những k ị ch b ả n test được chu ẩ n b ị
bằng cách đưa vào những cân nhắc c ủ a đ ầ u vào và đ ầ u ra c ủ a những bước xác đ ị nh bởi người dùng đ ể
đ ạ t đ ế n m ộ t m ụ c tiêu xác đ ị nh. Trong quá trình test, k ế t qu ả c ủ
a những bài test được xác đ ị nh bằng cách so sánh đ ầ u ra mong đợi với đ ầ u ra thực t ế .
 Đầu mục bài viết 
JAVASCRIPT RUBY PHP IOS ANDROID SWIFT RAILS LARAVEL REACTJS RUBY ON RAILS 

## Page 8

/
Khi vi ế
t những user-case, nhìn chung ngôn ngữ kinh doanh được yêu thích hơn ngôn ngữ k ỹ thu ậ t. Đ ể bao hàm t ấ t c ả các yêu c ầ u, ít nh ấ t m ộ t k ị ch b ả
n test được chu ẩ n b ị cho m ỗ i yêu c ầ u. Bằng cách này, mức đ ộ bao ph ủ
test được tăng lên và chúng ta có th ể đo được mức đ ộ bao ph ủ này sử d ụ ng m ộ t ma tr ậ
n dò tìm (traceability matrix). Trong ma tr ậ n dò tìm này, chúng ta sáng t ạ o m ộ
t b ả ng ma tr ậ n với những k ị ch b ả n test và những yêu c ầ u, và đánh m ộ t d ấ
u “X” vào những ô mà k ị ch b ả n test đ ạ t được các yêu c ầ u đ ặ t ra. M ụ c đích c ủ a vi ệ
c này là đ ể bao quát t ấ t c ả các yêu c ầ u.
Bên dưới chúng ta cùng tham kh ả o m ộ t testcase m ẫ
u: Tên k ị ch b ả n test: Thay đ ổ i m ậ t kh ẩ u thành công với đ ộ phức t ạ p vừa ph ả
i. Các bước test:
Mở trang ch ủ
Ch ọ
n vào nut Login Đi đ ế n “Pro le” và ch ọ n “Account Settings”
 Đầu mục bài viết 
JAVASCRIPT RUBY PHP IOS ANDROID SWIFT RAILS LARAVEL REACTJS RUBY ON RAILS 

## Page 9

/
Ch ọ
n “Change Password” Vào m ậ t kh ẩ u hi ệ n t ạ i và m ậ t kh ẩ u mới (Đ ộ phức t ạ p ở mức vừa ph ả
i) Ch ọ n Save
Yêu c ầ u tiên quy ế t: các bước trên c ầ n thực hi ệ n với m ộ t người dùng đang t ồ
n t ạ i trong h ệ th ố
ng. Dữ li ệ u test: User Name: [email protected]
Current Password: kariyer1234+
New Password: asdf1234
Mức ưu tiên test: Cao K ế t qu ả mong đợi: K ế t qu ả được chờ đợi là m ậ t kh ẩ u được thay đ ổ
i thành công và thông đi ệ p “Changed succesfully” s ẽ hi ể n th ị đ ể thông báo m ậ t kh ẩ
u đã được thay đ ổ i thành công.
3. Liên k ế
t tham kh ả
o https://www.swtestacademy.com/software-testing-techniques/
Những việc làm hấp dẫn
Delivery Manager (Agile, Scrum, .NET, Project/Delivery Management)
AS White Vietnam Negotiable
Scrum .NET Agile
Software Development Manager
Prudential 1,500 - 2,500 USD
Cloud Agile
[Senior/Junior] Java Developer
TIBCO Orchestra Networks Negotiable
J2EE Java Java Core Agile
 Đầu mục bài viết 
JAVASCRIPT RUBY PHP IOS ANDROID SWIFT RAILS LARAVEL REACTJS RUBY ON RAILS 

## Page 10

/
QA
 Facebook  Twitter  Google+
Bài viết liên quan
một số câu lệnh sql tester nên biết
tìm hiểu về nghề tester cho người mới bắt đầu
các loại kiểm thử phần mềm (phần 1)
[istqb] hỏi trả lời 10 câu tiếp theo (phần 2) chủ đề tranh luận lớn tiếp theo: vai trò của ai trong software testing
Chia sẻ
ABOUT THE SITE © COPYRIGHT 2017 BY TECH BLOG
 Đầu mục bài viết 
JAVASCRIPT RUBY PHP IOS ANDROID SWIFT RAILS LARAVEL REACTJS RUBY ON RAILS 
