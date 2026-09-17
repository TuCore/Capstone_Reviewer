# Ky thuat kiem thu bang quyet dinh

> Converted from original reference file. Formatting simplified.

## Page 1

9/21/2019
Kỹ thuật kiểm thử bảng quyết định https://freetuts.net/ky-thuat-kiem-thu-bang-quyet-dinh-1592.html 1/7
Đăng bởi: TuoiPham - Vào ngày: 06-01-2019
Kỹ thuật kiểm thử bảng quyết định
Bảng quyết định là một trong những kỹ thuật kiểm thử phầm mềm. Vậy Kiểm thử bảng quyết định
(Decision Table Testing) là gì? Tại sao Kiểm thử Bảng quyết định là quan trọng? Ưu điểm và nhược điểm
của kiểm thử bảng quyết định là gì? Hãy cùng tìm hiểu kỹ thuật này để test cases của bạn được bao phủ đầy đủ các điều kiện hơn nhé.
Nội dung chính
1. Kiểm thử bảng quyết định (Decision Table Testing) là gì?
Ví dụ 1: Cách tạo Bảng quyết định cho màn hình đăng nhập
Ví dụ 2: Cách tạo Bảng quyết định cho màn hình Upload
2. Tại sao Kiểm thử Bảng quyết định là quan trọng? 3. Ưu điểm và nhược điểm của kiểm thử bảng quyết định
1. Kiểm thử bảng quyết định (Decision Table Testing) là gì?
Kiểm thử bảng quyết định
(Decision Table Testing) là một kỹ
thuật kiểm thử phần mềm được sử dụng để kiểm thử hoạt
động của hệ thống khi kết hợp các đầu vào khác nhau. Đây là
một cách tiếp cận có hệ thống trong đó các kết hợp đầu vào
khác nhau và hành vi hệ thống tương ứng của chúng (Đầu ra)
được ghi lại dưới dạng bảng. Đó là lý do tại sao bảng quyết định cũng được gọi là bảng Nguyên nhân – Ảnh hưởng
(Cause-Effect), Nguyên nhân và Ảnh hưởng được ghi lại để
bảo đảm kiểm thử tốt hơn.
Bảng quyết định là biểu diễn dạng bảng với đầu vào ứng với quy tắc / trường hợp / điều kiện kiểm thử. Hãy xem ví dụ sau:

 
Reduce your operational costs
Reduce total cost of ownership by migrating to Charmed OpenStack
 

## Page 2

9/21/2019
Kỹ thuật kiểm thử bảng quyết định https://freetuts.net/ky-thuat-kiem-thu-bang-quyet-dinh-1592.html 2/7
Ví dụ 1: Cách tạo Bảng quyết định cho màn hình đăng nhập
Hãy tạo một bảng quyết định cho màn hình đăng nhập.
Điều kiện rất đơn giản, nếu người dùng nhập tên người dùng và mật khẩu chính xác, người dùng sẽ được chuyển hướng đến trang chủ. Nếu người dùng nhập đầu vào sai, thông báo lỗi sẽ được hiển thị.
Điều kiện Quy tắc 1 Quy tắc 2 Quy tắc 3
Quy tắc 4 Tên đăng nhập (T/F) F T F T
Mật khẩu (T/F) F F T T
Đầu ra (E/H) E E E H
Chú thích:
T - Tên người dùng / mật khẩu chính xác
F - Tên người dùng / mật khẩu sai
E - Thông báo lỗi được hiển thị H - Màn hình trang chủ được hiển thị
Mô tả:
1. Case 1 - Tên người dùng và mật khẩu đều sai: hiển thị một thông báo lỗi.
2. Case 2 - Tên người dùng đúng, nhưng mật khẩu sai: hiển thị một thông báo lỗi. 3. Case 3 - Tên người dùng sai, nhưng mật khẩu đúng: hiển thị một thông báo lỗi.
 

## Page 3

9/21/2019
Kỹ thuật kiểm thử bảng quyết định https://freetuts.net/ky-thuat-kiem-thu-bang-quyet-dinh-1592.html 3/7
4. Case 4 - Cả tên người dùng và mật khẩu đều chính xác: điều hướng đến trang chủ
Trong khi chuyển đổi những cases này sang test cases, chúng ta có thể tạo 2 kịch bản:
1. Nhập tên người dùng chính xác và mật khẩu chính xác, sau đó click vào đăng nhập, kết quả mong
đợi sẽ là người dùng sẽ được điều hướng đến trang chủ.
2. Và từ kịch bản dưới đây:
Nhập sai tên người dùng và mật khẩu sai, sau đó click vào đăng nhập, kết quả mong đợi sẽ là
người dùng sẽ nhận được thông báo lỗi.
Nhập tên người dùng chính xác và mật khẩu sai, sau đó click vào đăng nhập, kết quả mong đợi
sẽ là người dùng sẽ nhận được thông báo lỗi.
Nhập sai tên người dùng và mật khẩu chính xác, sau đó click vào đăng nhập, kết quả mong đợi
sẽ là người dùng sẽ nhận được thông báo lỗi. Về cơ bản chúng ta kiểm thử cùng một quy tắc.
Ví dụ 2: Cách tạo Bảng quyết định cho màn hình Upload
Hãy xem một hộp thoại yêu cầu người dùng tải ảnh lên với một số điều kiện như:
1. Chỉ có thể tải lên hình ảnh định dạng '.jpg'
2. Kích thước file dưới 32kb
3. Độ phân giải là 137 * 177.
Nếu không đáp ứng điều kiện nào, hệ thống sẽ đưa ra thông báo lỗi tương ứng, thông báo nêu rõ vấn đề. Nếu tất cả các điều kiện được đáp ứng, ảnh sẽ được cập nhật thành công.
Hãy tạo bảng quyết định cho trường hợp trên.
Điều kiện Case 1 Case 2 Case 3 Case 4 Case 5 Case 6 Case 7 Case 8
 

## Page 4

9/21/2019
Kỹ thuật kiểm thử bảng quyết định https://freetuts.net/ky-thuat-kiem-thu-bang-quyet-dinh-1592.html 4/7
Định dạng .jpg .jpg .jpg .jpg
Khác .jpg Khác .jpg
Khác .jpg Khác .jpg
Kích thước
Dưới
32kb
Dưới 32kb >= 32kb >= 32kb
Dưới
32kb
Dưới 32kb >= 32kb >= 32kb
Độ
phân giải
137*177
Khác
137 *
177 137*177
Khác 137 * 177
137*177
Khác
137 *
177 137*177
Khác 137 * 177
Đầu ra
Ảnh
được tải
lên
thành
công
Thông
báo lỗi:
độ
phân
giải
không
phù
hợp
Thông
báo lỗi:
kích
thước
không
phù hợp
Thông
báo lỗi:
kích
thước và
độ phân
giải không
phù hợp
Thông
báo lỗi:
định
dạng
không
phù hợp
Thông
báo lỗi:
định
dạng và
độ phân
giải
không
phù hợp
Thông
báo lỗi:
định
dạng và
kích
thước
không
phù hợp
Thông báo
lỗi: định
dạng, kích
thước và độ
phân giải
không phù
hợp
Đối với những điều kiện này, chúng ta có thể tạo 8 test cases khác nhau và đảm bảo phạm vi được bao
phủ hoàn toàn.
1. Tải lên một bức ảnh với định dạng '.jpg', kích thước nhỏ hơn 32kb, độ phân giải 137 * 177, sau đó
click vào “Upload”. Kết quả mong đợi là “Ảnh được tải lên thành công”.
2. Tải lên một bức ảnh với định dạng '.jpg', kích thước nhỏ hơn 32kb, độ phân giải khác 137 * 177, sau
đó click vào “Upload”. Kết quả dự kiến là “Thông báo lỗi: độ phân giải không phù hợp” được hiển thị.
3. Tải lên một bức ảnh với định dạng '.jpg', kích thước hơn 32kb và độ phân giải là 137 * 177, sau đó
click vào “Upload”. Kết quả dự kiến là “Thông báo lỗi: kích thước không phù hợp” sẽ được hiển thị.
4. Tải lên một bức ảnh với định dạng '.jpg', kích thước nhỏ hơn 32kb và độ phân giải khác 137 * 177,
sau đó click vào “Upload”. Kết quả dự kiến là “Thông báo lỗi: kích thước và độ phân giải không phù
hợp” sẽ được hiển thị.
5. Tải lên một bức ảnh với định dạng khác '.jpg', kích thước nhỏ hơn 32kb và độ phân giải là 137 * 177,
sau đó click vào “Upload”. Kết quả dự kiến là “Thông báo lỗi: định dạng không phù hợp” sẽ được hiển thị.
 

## Page 5

9/21/2019
Kỹ thuật kiểm thử bảng quyết định https://freetuts.net/ky-thuat-kiem-thu-bang-quyet-dinh-1592.html 5/7
6. Tải lên một bức ảnh với định dạng khác '.jpg', kích thước nhỏ hơn 32kb và độ phân giải khác 137 *
177, sau đó click vào “Upload”. Kết quả dự kiến là “Thông báo lỗi” định dạng và độ phân giải không
phù hợp” sẽ được hiển thị.
7. Tải lên một bức ảnh với định dạng khác với '.jpg', kích thước hơn 32kb và độ phân giải là 137 * 177,
sau đó click vào “Upload”. Kết quả dự kiến là “Thông báo lỗi: định dạng và kích thước không phù
hợp” sẽ được hiển thị.
8. Tải lên một bức ảnh với định dạng khác '.jpg', kích thước hơn 32kb và độ phân giải khác 137 * 177,
sau đó click vào “Upload”. Kết quả dự kiến là “Thông báo lỗi: định dạng, kích thước và độ phân giải không phù hợp” sẽ được hiển thị.
2. Tại sao Kiểm thử Bảng quyết định là quan trọng?
Kỹ thuật kiểm thử Bảng quyết định trở nên quan trọng khi cần
phải kiểm thử sự kết hợp khác nhau. Bảng quyết định cũng
giúp bao phủ đầy đủ các trường hợp kiểm thử đối với logic
nghiệp vụ phức tạp.
Trong Kỹ thuật phần mềm, giá trị biên và phân vùng tương
đương là các kỹ thuật tương tự được sử dụng để đảm bảo
phạm vi được bao phủ. Các kỹ thuật này được sử dụng nếu
hệ thống hiển thị đầu ra tương tự cho một tập hợp lớn các
đầu vào. Tuy nhiên, đối với mỗi bộ giá trị đầu vào, hệ thống
xử lý khác nhau, kỹ thuật giá trị biên và phân vùng tương
đương không hiệu quả trong việc đảm bảo phạm vi kiểm thử được bao phủ.
Trong trường hợp này, kiểm thử bảng quyết định là một lựa chọn tốt. Kỹ thuật này có thể đảm bảo phạm vi
bao phủ và việc trình bày đơn giản để dễ giải thích và sử dụng.
Bảng này có thể được sử dụng làm tài liệu tham khảo vì nó dễ hiểu và bao gồm tất cả các kết hợp.
Tầm quan trọng của kỹ thuật này rất rõ ràng khi số lượng đầu vào tăng lên. Số lượng kết hợp có thể lên
đến 2 ^ n, trong đó n là số lượng Đầu vào. Đối với n = 10, rất phổ biến trong kiểm thử web, số lượng kết
hợp sẽ là 1024. Rõ ràng, bạn không thể kiểm thử tất cả nhưng bạn sẽ chọn một tập hợp con và có thể kiểm thử dựa trên kỹ thuật kiểm thử bảng quyết định.
 

## Page 6

9/21/2019
Kỹ thuật kiểm thử bảng quyết định https://freetuts.net/ky-thuat-kiem-thu-bang-quyet-dinh-1592.html 6/7
3. Ưu điểm và nhược điểm của kiểm thử bảng quyết định
Ưu điểm:
Cách xử lý của hệ thống khác nhau đối với đầu vào
khác nhau, cả phân vùng tương đương và phân tích giá
trị biên sẽ không giúp ích, nhưng có thể sử dụng bảng
quyết định.
Việc trình bày rất đơn giản, có thể dễ dàng giải thích và
được sử dụng để phát triển.
Bảng này sẽ giúp thực hiện các kết hợp hiệu quả và có
thể đảm bảo phạm vi bao phủ tốt hơn để kiểm thử.
Bất kỳ điều kiện nghiệp vụ phức tạp nào cũng có thể dễ
dàng khi sử dụng bảng quyết định. Có thể bao phủ 100% khi các kết hợp đầu vào thấp, kỹ thuật này có thể đảm bảo phạm vi bao phủ.
Nhược điểm:
Nhược điểm chính là khi số lượng đầu vào tăng lên, bảng sẽ trở nên phức tạp hơn -------------------#####-------------------
Khóa học nên xem
Luyện thi lấy chứng chỉ quốc tế ISTQB Foundation cho Tester Luyện thi lấy chứng chỉ quốc tế ISTQB Foundation cho Tester
Nguồn: freetuts.net
Chuỗi bài viết được tham khảo hoặc dịch lại từ nhiều nguồn như: TutorialsPoint, Guru99.
 BÀI KẾ SAU BÀI KẾ TIẾP 
Những việc làm hấp dẫn
Tester (QA, QC, English)
 

## Page 7

9/21/2019
Kỹ thuật kiểm thử bảng quyết định https://freetuts.net/ky-thuat-kiem-thu-bang-quyet-dinh-1592.html 7/7
Ekino VietNam Ho Chi Minh Negotiable
QA QC Tester English
Automation Tester
DEK TECHNOLOGIES PTY. LTD Ho Chi Minh Negotiable
Tester Automation Test
Senior Tester
Wize Solutions Ha Noi Up to $1,200
Tester
BÀI GẦN ĐÂY
Giám sát và kiểm soát kiểm thử
Tài liệu kiểm thử
Cách tạo Test Plan
Tổ chức nhóm kiểm thử
Phân tích rủi ro dự án và giải pháp trong quản lý
kiểm thử
Quy trình quản lý kiểm thử
Vai trò và Trách nhiệm của Test Manager
Kiểm thử Use Case
Kỹ thuật kiểm thử chuyển đổi trạng thái Kỹ thuật kiểm thử bảng quyết định








 
 
