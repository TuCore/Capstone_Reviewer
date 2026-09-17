# Ung dung ky thuat kiem thu trong qua trinh tao testcase (Viblo)

> Converted from original reference file. Formatting simplified.

## Page 1

/
Thị Thoa Bùi @thoabt Follow
 1.0K  82 
21 Published Oct 26th, 2015 12:55 PM - 7 min read
 4.9K  0  3
ứng dụng các kỹ thuật kiểm thử trong quá trình tạo Testcase.
Testing QA
Đối với các bạn theo nghề kiểm thử viên chắc không còn lạ lẫm với việc thiết kế các ca kiểm thử. Nhưng làm thế nào
để biết tập các testcase của mình đưa ra đã bao phủ được hết các trường hợp.
Hôm nay, Bài viết của mình sẽ giới thiệu về một số các phương pháp - kỹ thuật thiết kế testcase trong quá trình
thiết kế ca kiểm thử nhằm giải quyết vấn trên. Các phương pháp được mình đề cập tới thuộc các phương pháp kiểm thử hộp đen.
1. Phương pháp Phân lớp tương đương
Phân lớp tương đương có đặc điểm là :
Một phương pháp kiểm thử chia miền đầu vào của một chương trình thành các lớp dữ liệu tương đương nhau
Tất cả các giá trị trong một vùng tương đương sẽ cho một kết quả đầu ra giống nhau Có thể test một giá trị đại diện trong vùng tương đương
Thiết kế Test-case bằng phân lớp tương đương theo các nguyên tắc :
Xác định số lớp tương đương hợp lệ
Xác định số lớp tương đương không hợp lệ
Ví dụ: Kiểm thử Form login bao gồm: User là một ô text và Password là một ô text
Yêu cầu: Thiết kế test case sao cho khi người dùng nhập user vào ô text thì chỉ cho nhập số ký tự [6 – 20 ] Phân tích
các ca kiểm thử như sau: Các lớp tương đương được xác định là: <6,[6-20] và >20. Như vậy, các ca kiểm thử theo phương pháp này là:



## Page 2

/
+/ Nhập vào trường hợp không hợp lệ thứ nhất: nhập 5 ký tự
+/ Nhập vào một trường hợp hợp lệ:nhập 7 ký tự +/ Nhập vào trường hợp không hợp lệ thứ hai: nhập vào 21 ký tự.
2. Phương pháp Giá trị biên
Phân tích giá biên có đặc điểm :
Một phương pháp có các điều kiện biên là những giá trị đầu vào cho những ca kiểm thử
Là trường hợp đặc biệt của phân lớp tương đương, dựa trên những phân vùng tương đương tester sẽ xác định
giá trị biên giữa những phân vùng này và lựa chọn test case phù hợp.
Phương pháp này bổ sung ca kiểm thử cho phương pháp phân lớp tương đương trên.
Một số quy tắc có thể xác định các ca kiểm thử là:
Giá trị nhỏ nhất.
Giá trị gần kề lớn hơn giá trị nhỏ nhất
Giá trị bình thường
Giá trị gần kề bé hơn giá trị lớn nhất
Giá trị biên lớn nhất.
Ví dụ : Một text box cho phép nhập tuổi của con người trong khoảng từ [0-100]. Thiết kế các trường hợp kiểm thử theo phương pháp này là:
+/ Giá trị nhỏ nhất: 0
+/ Giá trị gần kề lớn hơn giá trị nhỏ nhất: 1
+/ Giá trị bình thường: 50 +/ Giá
trị gần kề bé hơn giá trị lớn nhất: 99 +/ Giá trị biên lớn nhất: 100
3. Đoán lỗi
Phương pháp đoán lỗi có đặc điểm :
Là phương pháp dựa trên phỏng đoán cả bằng trực giác và kinh nghiệm, tester có thể viết danh sách các loại
lỗi có thể hay các trường hợp dễ xảy ra lỗi và sau đó viết các ca kiểm thử dựa trên danh sách đó.
Đây là một phương pháp bổ sung ca kiểm thử cho các phương pháp trên dựa vào kinh nghiệm của tester là
chính.
Đối phương pháp này, không có một quy trình cụ thể nào để áp dụng, chủ yếu phụ thuộc vào kinh nghiệm về kiểm
thử của mỗi tester .
Ví dụ: Ở màn hình login, đôi khi developer code thì gán user name là “admin” và pass là rỗng hoặc “123” vì vậy khi thực hiện test mình nên test cả case này.


## Page 3

/
Phương pháp chuyển trạng thái có đặc điểm :
Là phương pháp quan sát theo dõi sự chuyển từ trạng thái này sang trạng thái khác khi có tác động gì đó tới
chương trình phần mềm.
Cho phép các tester xem sự phát triển phần mềm trong một số điều kiện trạng thái của nó, các quá trình
chuyển đổi giữa các trạng thái và các điều kiện nhập đầu vào và các sự kiện kích hoạt thay đổi trạng thái
Bổ sung các ca kiểm thử để phát hiện ra lỗi mà có thể không phát hiện được bằng điều kiện input, output bởi
các phương pháp trên.
Ví dụ: Test một quy trình mua bán online như sau :
1.Giỏ hàng trên một trang mua bán trực tuyến được bắt đầu với trạng thái là rỗng (không có món hàng nào).
2.Khi bạn chọn một sản phẩm thì nó sẽ được đưa vào giỏ hàng. Bạn cũng có thể bỏ chọn các món hàng trong
giỏ hàng.
3.Khi bạn quyết định mua hàng, thì sẽ xuất hiện màn hình tổng hợp các món hàng đang có trong giỏ cùng với
thông tin về giá tiền, số lượng và tổng tiền của giỏ hàng, để cho bạn xác nhận xem đúng hay chưa.
4.Nếu bạn thấy số lượng hàng và giá tiền OK thì bạn sẽ được chuyển sang trang thanh toán.
5.Ngược lại bạn sẽ quay lại trang mua hàng (lúc này bạn có thể bỏ chọn các món hàng bạn muốn bỏ bớt).
Yêu cầu: Viết Testcase cho ví dụ trên.
Hướng dẫn áp dụng kỹ thuật chuyển trạng thái này: Bước 1. Vẽ sơ đồ chuyển đổi trạng thái theo các yêu cầu trên:
Bước 2. Lập bảng mô tả trạng thái tương ứng với sơ đồ trạng thái trên:


## Page 4

/
Related More from Thị Thoa Bùi
Chú ý: Trong bảng trên ô chứa dấu – là trạng thái không hợp lệ Bước 3. Từ bảng mô tả trạng thái trên, có thể thiết kế các ca kiểm thử như sau:
Hi vọng, các phương pháp trên có thể giúp các bạn dễ dàng hơn trong việc thiết kế kịch bản kiểm thử cho mỗi ứng
  
Hien91
15 min read
 15104  8  1   8
Tìm hiểu về các loại kiểm thử phần mềm
Thị Thoa Bùi
8 min read
 1814  2  0   2
Sử dụng kỹ thuật Đoán Lỗi trong Testing
Tran Thi Huong Trang
15 min read
 12902  1  1   3
Tìm hiểu về kỹ thuật phân tích giá trị biên và phân vùng tương đương trong kiểm thử hộp đen
Nguyen Thu Phuong
3 min read
 997  1  0   -1
Pairwise Testing - Kiểm thử cặp đôi


## Page 5

/
Comments
Thị Thoa Bùi
24 min read
 396  1  0   3
Kiểm thử các tính năng thống kê trên phần mềm
Thị Thoa Bùi
8 min read
 1814  2  0   2
Sử dụng kỹ thuật Đoán Lỗi trong Testing
Thị Thoa Bùi
10 min read
 744  2  1
  5
Bạn chọn QA là nghề nghiệp hay công việc ?
Thị Thoa Bùi
6 min read
 1005  3  0
  2
Kiểm soát phạm vi dự án
 Login to comment
RESOURCES
Posts
Organizations Questions
Tags Videos
Authors Discussions
Recommend System Tools
Machine Learning System Status
SERVICES
Viblo Code Viblo CV
MOBILE APP
LINKS
  
© 2019 Viblo . All rights reserved. Feedback Help FAQs RSS Terms

