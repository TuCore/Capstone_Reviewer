# Ban dich ISTQB (haposoft)

> Converted from original textbook file. Formatting simplified.

https://blog.haposoft.com/kiem-thu-phan-mem-cac-nguyen-tac-co-ban-1/

# Kiểm thử phần mềm: Các nguyên tắc cơ bản ( Phần 1)

###### duongtt

29 August 2018

software testing

Đây là series tóm tắt từ cuốn sách: FOUNDATIONS OF SOFTWARE TESTING ISTQB CERTIFICATION của tác giả Dorothy Graham, Erik van Veenendaal, Isabel Evans và Rex Black và một số kinh nghiệm của cá nhân trong quá trình làm việc nhằm cung cấp cho các bạn một cái nhìn tổng quan về kiểm thử phần mềm và các kiến thức cơ bản về kiểm thử, các kỹ thuật dùng trong kiểm thử và các công cụ hỗ trợ.

Phần này, mình sẽ giới thiệu các quy tắc của việc kiểm thử: tại sao cần được kiểm thử, mục đích, mục tiêu và các giới hạn của nó là gì, các nguyên tắc phải áp dụng khi kiểm thử, các quy trình mà tester phải làm theo và một số yếu tố tâm lý mà tester cần phải cân nhắc, xem xét trong khi làm việc. Sau khi đọc chương này, mọi người sẽ hiểu rõ hơn các nguyên tắc của việc kiểm thử và có thể mô tả, áp dụng thực tế các nguyên tắc đó.Trong bài viết lần này, mình sẽ giới thiệu nội dung cơ bản đó là Kiểm thử là gì, sự cần thiết của nó và các nguyên tắc trong kiểm thử .

## 1. Sự cần thiết của việc kiểm thử.

### 1.1. Giới thiệu và bối cảnh hệ thống phần mềm

Hệ thống phần mềm là một phần không thể thiếu của cuộc sống, từ các ứng dụng kinh doanh tới các sản phẩm tiêu dùng. Phần mềm không làm việc một cách chính xác có thể dẫn đến nhiều vấn đề bao gồm việc mất tiền, thời gian, uy tín của doanh nghiệp. Vì vậy, cần kiểm tra mọi thứ, bất cứ thứ gì chúng ta tạo ra đều có thể có sai sót. kiểm thử giúp giảm thiểu các lỗi xảy ra trong hệ thống, các rủi ro tiềm ẩn có thể xảy ra.

### 1.2. Nguyên nhân gây ra lỗi trong các hệ thống phần mềm.

Một số nguyên nhân gây ra lỗi:

Lỗi từ trong code, hệ thống hoặc trong tài liệu.

Con người: thiếu kinh nghiệm, không nhận được thông tin đúng, hiểu lầm yêu cầu của hệ thống hoặc là bất cẩn, mệt mỏi, áp lực về thời gian cũng là nguyên nhân gây ra những sai sót, bởi vì những yếu tố đó ảnh hưởng đến khả năng đưa ra quyết định chính xác.

Kỹ thuật và các quy trình nghiệp vụ phức tạp, code, cơ sở hạ tầng, thay đổi công nghệ hoặc là có nhiều tương tác với hệ thống.

Ngoài ra, điều kiện môi trường cũng gây ra thất bại đối với một hệ thống phần mềm. ví dụ, từ trường mạnh, điện trường, hoặc ô nhiễm có thể gây ra lỗi trong phần cứng hoặc phần mềm

Vậy thì lỗi phát sinh khi nào?

Trong hình 1.1, chúng ta có thể thấy các defects(khuyết thiếu) có thể phát sinh ở những giai đoạn nào trong 4 yêu cầu đối với một sản phẩm Hình 1.1. Các loại lỗi (error) và khuyết thiếu (defect).

Yêu cầu 1: được triển khai chính xác, hiểu yêu cầu của khách hàng, thiết kế chính xác để đáp ứng yêu cầu đó, xây dựng đúng theo thiết kế và cung cấp các yêu cầu đó phù hợp với các thuộc tính: chức năng và phi chức năng.

Yêu cầu 2: phần mềm được lập trình và khi xuất hiện các lỗi (error) và khuyết thiếu (defect). chúng có thể được tìm thấy và sửa chữa trong giai đoạn kiểm thử.

Yêu cầu 3: các khuyết thiếu (defect) ở yêu cầu 3 khó xử lý hơn. phần mềm được xây dựng đúng với thiết kế nhưng có những sai sót trong khi thiết kế. Nếu chúng ta không xem lại chi tiết các yêu cầu thì sẽ không thể phát hiện ra những sai sót đó. khi phát hiện ra thì cũng khó sửa chữa vì phải sửa lại từ thiết kế.

Yêu cầu 4: Nếu chỉ kiểm tra sản phẩm có đáp ứng thiết kế và yêu cầu không thôi thì có thể có những lỗi, sai sót tiềm ẩn. Những lỗi, sai sót mà khách hàng báo cáo trong kiểm thử chấp nhận (acceptance test) hoặc trong khi sử dụng trực tiếp có thể gây ra tổn thất rất lớn.

Chi phí của các khuyết thiếu (defect)

"A stitch in time saves nine" Các bạn có biết câu tục ngữ này có nghĩa là gì không?. Nó có nghĩa là một mũi khâu đúng lúc thì sẽ tiết kiệm được 9 mũi khâu(xuất phát từ việc nếu 1 người bị lỗ thủng trên áo, nếu khâu vá lại ngay thì sẽ tránh khỏi việc lỗ thủng đấy sẽ bị rách to hơn và cần đến nhiều mũi khâu hơn). Câu nói trên dùng để khuyên mọi người nên xử lý một việc kịp thời, ngay và luôn, vì nếu để càng lâu thì mọi thứ càng rắc rối và mất nhiều thời gian hơn để giải quyết.

Hình 1.2. Chi phí của các lỗi(error), khuyết thiếu(defect).Ở hình trên ta có thể thấy được những lỗi, sai sót mà được phát hiện ngay từ giai đoạn yêu cầu thì chi phí để tìm và sửa lỗi ở giai đoạn này tương đối ít. Chi phí sẽ tăng lên theo từng giai đoạn phát triển của hệ thống.

### 1.3. Vai trò của kiểm thử trong phát triển phần mềm, bảo trì và hoạt động.

Lỗi có thể xảy ra ở bất kỳ giai đoạn nào trong vòng đời phát triển của phần mềm. Do vậy kiểm thử rất cần thiết trong quá trình phát triển và bảo trì để xác định các sai sót, lỗi, giảm mức độ thất bại (failed) trong môi trường hoạt động và nâng cao chất lượng của hệ thống vận hành. Kiểm thử giúp tìm lỗi trong giao diện người dùng, dữ liệu đầu vào, giải thích dữ liệu đầu ra và tìm những những lỗi tiềm ẩn.

### 1.4. Kiểm thử và chất lượng.

Kiểm thử giúp đo lường chất lượng phần mềm dựa vào số lỗi được tìm ra, thực thi kiểm thử và độ bao phủ hệ thống.Chất lượng là gì?

Theo bảng định nghĩa thuật ngữ của ISTQB thì chất lượng không chỉ bao gồm việc đáp ứng được những yêu cầu đã xác định mà còn đáp ứng cả nhu cầu và mong đợi của người dùng và khách hàng.kiểm thử và chất lượng có liên quan đến nhau như nào:

Kiểm thử có thể đo lường chất lượng của phần mềm về các khiếm khuyết được tìm thấy (cả yêu cầu chức năng và phi chức năng) và cả các đặc tính: độ tin cậy, khả năng sử dụng, tính hiệu quả, bảo trì, tính di động.

Kiểm thử tạo độ tin cậy vào chất lượng của phần mềm nếu tìm thấy rất ít hoặc không có lỗi.

Cải thiện chất lượng của hệ thống trong tương lai bằng cách rút ra những bài học từ những dự án trước. Hiểu được nguyên nhân gốc của các khiếm khuyết được tìm thấy trong dự án.

Kiểm thử là một trong những hoạt động đảm bảo chất lượng.

Phân tích nguyên nhân gốc rễ là gì?

Khi phát hiện thấy lỗi, chúng ta sẽ theo dõi xem nó có bị lỗi trở lại hay không và tìm hiểu xem nguyên nhân gây ra lỗi đấy là gì.Ví dụ: khi máy in của công ty có vấn đề với việc in bị fail nhiều lần.mọi người mới tìm hiểu các nguyên nhân có thể gây ra lỗi ở máy in. Sau đó nhóm lại để tìm nguyên nhân cơ bản hoặc nguyên nhân gốc rễ của các vấn đề. Một số nguyên nhân tìm thấy có thể là:

Máy in hết nguồn cung cấp (mực hoặc giấy).

Phần mềm điều khiển in có vấn đề.

Phòng để máy in quá nóng trong khi máy in vẫn đang hoạt động.

Nguyên nhân có thể nhìn thấy ngay được là máy in hết nguồn cung cấp( mực, giấy), điều này có thể xảy ra bởi vì:

Không có ai chịu trách nhiệm kiểm tra giấy và mực trước khi in. Nguyên nhân gốc có thể là không có quy trình kiểm tra mực/ giấy in trước khi sử dụng.

nhân viên không biết thay hộp mực. Nguyên nhân gốc rễ là nhân viên không được đào tạo hoặc đưa ra hướng dẫ về việc chăm sóc máy in.

Không có nguồn cung thay thế khi máy in hết mực và giấy. Nguyên nhân gốc rễ là không có quy trình kiểm soát và đặt hàng dự trữ.

Kiểm thử giúp chúng ta phát hiện ra lỗi, những khả năng thất bại đang tiềm ẩn trong quá trình phát triển, bảo trì và hoạt động phần mềm. Tìm được nguyên nhân gốc gây ra lỗi giúp phần mềm giảm nguy cơ thất bại(failed) xảy ra trong môi trường hoạt động và nâng cao chất lượng phần mềm.

### 1.5. Kiểm thử bao nhiêu là đủ?

Đối với 1 phần mềm, chúng ta không thể nói được rằng nó không còn lỗi nữa, perfect rồi, bàn giao cho khách hàng thôi. Có thể những lỗi các bạn phát hiện ra, fix và ko còn hiển hiện nữa nhưng còn những lỗi tiềm tàng thì sao? Các bạn có chắc chắn rằng mình có thể cover hết được các tình huống có thể xảy ra đối với phần mềm hay không? Câu trả lời là không. Vậy thì kiểm thử như thế nào là đủ? Cái này cũng rất khó có thể xác định.

Ví dụ: trong dự án thực tế ở một màn hình có 15 trường nhập input, mỗi trường có thể có 5 giá trị. sau đó kiểm tra tất cả các giá trị kết hợp đầu vào thì có 30 517 578 125(5^15)trường hợp kiểm tra. Kiểm tra các trường với 1 chữ số với các giá trị 2,3,4 sẽ làm cho các ca kiểm thử được kỹ hơn nhưng nó không cung cấp nhiều thông tin hơn kiểm tra với giá trị 3. Phụ thuộc vào thời gian và ngân sách chúng ta không thể kiểm tra hết tất cả các trường hợp nêu trên. Thay vào chỉ test giới hạn số lượng testcase.

Một ví dụ nữa về dự án thực tế mà công ty vừa release cho khách hàng. khi đã bàn giao cho khách hàng rồi nhưng hoạt động kiểm thử vẫn tiếp tục được thực hiện và vẫn tìm thấy trong hệ thống còn rất nhiều lỗi.Kiểm thử bao nhiêu là đủ? chúng ta phải dựa trên việc đánh giá và quản lý rủi ro, bao gồm các rủi ro kỹ thuật và kinh doanh liên quan đến các ràng buộc sản phẩm và dự án như thời gian và ngân sách

### 2. Kiểm thử là gì?.

Định nghĩa: Kiểm thử là quá trình bao gồm:

Lập kế hoạch, chuẩn bị và đánh giá các hoạt động phần mềm và các sản phẩm.

Kiểm thử tĩnh và kiểm thử động

Xác định đáp ứng yêu cầu quy định.

Chứng minh phù hợp với mục đích.

Phát hiện các khiếm khuyết.

Hoạt động kiểm thử tồn tại trước và sau khi thực hiện kiểm thử, bao gồm các hoạt động sau:

Lên kế hoạch và xử lý

Lựa chọn các điều kiện kiểm thử

Thiết kế các trường hợp kiểm thử (viết testcase)

Kiểm tra kết quả

Đánh giá các tiêu chuẩn hoàn thành

Báo cáo quá trình kiểm thử

Hoàn thành các hoạt động kiểm kết thúc kiểm thử sau một giai đoạn kiểm thử đã hoàn thành

Đóng gói sản phẩm

Đánh giá tài liệu ( bao gồm cả mã nguồn(souce code)

Phân tích tĩnh.

Các mục tiêu kiểm thử thường là:

Tìm các lỗi, các thiếu sót trong hệ thống.

Đạt được sự tin cậy về chất lượng.

Cung cấp thông tin để đưa ra quyết định.

Ngăn chặn các lỗi có thể xảy ra.

Mục tiêu của kiểm thử trong các giai đoạn khác nhau

Phát triển kiểm thử: Các khiếm khuyết được xác định và có thể được sửa chữa.

Kiểm thử chấp nhận: Xác nhận hệ thống hoạt động như mong đợi và đạt được sự tin tưởng, phần mềm đã đáp ứng được yêu cầu.

Bảo trì : Đảm bảo không xuất hiện các khiếm khuyết mới khi thay đổi phần mềm.

Vận hành: Đánh giá các đặc điểm của hệ thống như độ tin cậy và tính sẵn có.

## 3.Các nguyên tắc trong kiểm thử

Nguyên tắc 1: kiểm thử cho thấy sự hiện diện của lỗi:

Kiểm thử có thể cho thấy phần mềm đang có lỗi, nhưng không thể chứng minh rằng trong phần mềm không có lỗi nào. Kiểm thử được thực hiện bằng những kỹ thuật khác nhau, làm giảm xác suất lỗi chưa tìm thấy vẫn còn trong phần mềm. Vì vậy cần tìm được càng nhiều lỗi càng tốt.

Nguyên tắc 2: Kiểm thử toàn diện là không thể:

Nguyên tắc này cho rằng kiểm thử tất cả mọi thứ một cách toàn vẹn là không thể( sự kết hợpcủa tất cả input và điều kiện tiên quyết) trừ những phần mềm bao gồm ít trường hợp thì có thể kiểm thử toàn bộ. Thay vì kiểm thử toàn bộ, việc phân tích rủi ro và dựa trên mức độ ưu tiên chúng ta có thể tập trung việc kiểm thử vào một số điểm cần thiết và có nguy cơ lỗi cao hơn.

Nguyên tắc 3: kiểm thử càng sớm càng tốt:

Các hoạt động kiểm thử phần mềm nên bắt đầu càng sớm càng tốt trong phần mềm hay trong chu trình phát triển hệ thống và nên tập trung vào các mục tiêu xác định. kiểm thử phần mềm từ giai đoạn đầu sẽ giúp phát hiện bug sớm hơn.

Nguyên tắc 4: sự tập trung của các lỗi:

Thông thường, lỗi tập trung ở một số module, thành phần chức năng chính của hệ thống. Nếuxác định được điều này chúng ta sẽ tập trung vào tìm kiếm lỗi quanh khu vực được xác định. Nó được coi là một trong những cách hiệu quả nhất để thực hiện kiểm tra hiệu quả.

Để hiểu rõ hơn nguyên tắc này, ta cần xem xét 3 điều sau:

Nguyên tắc tổ gián: chỗ nào có 1 vài con gián thì ở đâu đó xung quanh nó sẽ có cả tổ gián -> có rất nhiều gián -> chỗ nào có 1 vài bug thì xung quanh, gần chỗ đó sẽ có nhiều bug.

Nguyên tắc Pareto (80/20): thông thường 20% chức năng quan trọng trong một chương trình có thể gây ra đến 80% tổng số bug phát hiện được trong chương trình đó.

Kiểm thử toàn bộ là không thể(nguyên tắc thứ 2): do đó cần phải ananlysis (phân tích) + priorities (tính toán mức độ ưu tiên) để quyết định tập trung vào test chỗ nào.

=> Test kỹ chức năng quan trọng => tìm bug => test những gì liên quan và những chức năng gần nó để tìm ra bug nhiều hơn.

Nguyên tắc 5: Pesticide paradox:

Nếu sử dụng cùng một tập các trường hợp kiểm thử liên tục, sau một thời gian các trườnghợp kiểm thử không tìm thấy lỗi nào mới. Hiệu quả của các trường hợp kiểm thử bắt đầu giảm xuống sau một số lần thực hiện, vì vậy chúng ta phải luôn rà soát và sửa đổi các trường hợp kiểm thử trên một khoảng thời gian thường xuyên.

Nguyên tắc 6: kiểm thử phụ thuộc vào ngữ cảnh:

Theo nguyên tắc này thì việc kiểm thử phụ thuộc vào ngữ cảnh và chúng ta phải tiếp cậnkiểm thử theo nhiều ngữ cảnh khác nhau. Nếu bạn đang kiểm thử ứng dụng web và ứng dụng di động bằng cách sử dụng chiến lược kiểm thử giống nhau, thì đó là sai. Chiến lược để kiểm thử ứng dụng web sẽ khác với kiểm thử ứng dụng cho thiết bị di động của Android. Ví dụ như một phần mềm an toàn bảo mật sẽ được test khác so với 1 website thương mại điện tử.

Nguyên tắc 7: Absence-of-errors fallacy (không có lỗi-sai lầm):

Việc không tìm thấy lỗi trên sản phẩm không đồng nghĩa với việc sản phẩm đã sẵn sàng đểtung ra thị trường. không tìm thấy lỗi cũng có thể là do các trường hợp kiểm thử được tạo ra chỉ nhằm kiểm tra những tính năng được làm đúng theo yêu cầu thay vì tìm kiếm lỗi mới. Đồng thời việc tìm ra và sửa lỗi sẽ không có tác dụng nếu như hệ thống được xây dựng mà không sử dụng được hoặc là không đáp ứng được nhu cầu mong đợi của người dùng.

Trên đây mình vừa giới thiệu khái quát về: định nghĩa, sự cần thiết cũng như là các quy tắc cơ bản của kiểm thử. Phần sau mình sẽ giới thiệu với các bạn về quy trình kiểm thử cơ bản và các yếu tố tâm lý học trong kiểm thử.

Phần tiếp theo: Kiểm thử phần mềm: Các nguyên tắc cơ bản (Phần 2)

https://blog.haposoft.com/kiem-thu-phan-mem-cac-nguyen-tac-co-ban-2/

# Kiểm thử phần mềm: Các nguyên tắc cơ bản (Phần 2)

###### duongtt

31 August 2018

software testing

Đây là series tóm tắt từ cuốn sách: FOUNDATIONS OF SOFTWARE TESTING ISTQB CERTIFICATION của tác giả Dorothy Graham, Erik van Veenendaal, Isabel Evans và Rex Black và một số kinh nghiệm của cá nhân trong quá trình làm việc nhằm cung cấp cho các bạn một cái nhìn tổng quan về kiểm thử phần mềm và các kiến thức cơ bản về kiểm thử, các kỹ thuật dùng trong kiểm thử và các công cụ hỗ trợ.Để tiếp nối nội dung từ bài viết Kiểm thử phần mềm: Các nguyên tắc cơ bản (Phần 1), trong bài viết lần này, mình sẽ giới thiệu Các quy trình kiểm thử cơ bản và các yếu tố tâm lý học ảnh hưởng đến kiểm thử.

## 1. Quy trình kiểm thử cơ bản

### 1.1 Lập kế hoạch và giám sát việc kiểm thử (Test planning and control).

Các bước xây dựng được một kế hoạch kiểm thử.

Xác định phạm vi, các rủi ro và xác định các mục tiêu của việc kiểm thử:

Xem xét những phần mềm, những thành phần, những hệ thống hay sản phẩm khác thuộc phạm vi kiểm thử.

Những rủi ro kỹ thuật, rủi ro của dự án, rủi ro của sản phẩm và rủi ro trong nghiệp vụ cần được giải quyết.

Mục tiêu của việc kiểm thử là phát hiện ra các lỗi, chứng minh rằng phần mềm đáp ứng được yêu cầu, phù hợp với mục đích hoặc đánh giá được chất lượng cũng như các thuộc tính của phần mềm.

Xác định cách tiếp cận kiểm thử( các công nghệ, item test, phạm vi bao quát, xác định và liên kết giữa các nhóm tham gia kiểm thử, testware):

Xem xét tiến hành kiểm thử như thế nào.

Những công nghệ nào được sử dụng.

Cần kiểm thử những gì.

Phạm vi bao quát như thế nào

Thực thi chính sách kiểm thử và chiến lược kiểm thử: Trong quá trình lập kế hoạch kiểm thử phải tuân thủ các chính sách, chiến lược hoặc làphải được sự đồng ý của các bên liên quan.

Xác định yêu cầu về nguồn lực test như con người, môi trường test, PCs…

Lập kế hoạch phân tích việc kiểm thử, nhiệm vụ thiết kế, thực thi việc kiểm thử, thi hành và đánh giá:

Chúng ta cần một kế hoạch của tất cả các hoạt động và nhiệm vụ để có thể theo dõi và đảmbảo hoàn thành việc kiểm thử đúng thời gian.

Xác định tiêu chuẩn kết thúc (exit criteria):

Cần thiết lập tiêu chuẩn để đảm bảo việc theo dõi các hoạt động kiểm thử và kiểm tra cụ thể được công việc đã hoàn thành ở mức độ như thế nào trước khi kết thúc kiểm thử.

Chúng ta cần kiểm soát và đo lường tiến độ so với kế hoạch, vì vậy kiểm soát việc kiểm thử là một hoạt động liên tục. Kiểm soát kiểm thử có những nhiệm vụ chính sau đây:

Đo lường và phân tích kết quả của việc đánh giá và kiểm thử:

Để thống kê được có bao nhiêu trường hợp kiểm thử đã thực hiện.

Theo dõi, kiểm soát số lượng các trường hợp được thông qua, bao nhiêu trường hợp thất bại, số lượng, loại và tầm quan trọng của các lỗi, sai sót trong các báo cáo.

Theo dõi và lập hồ sơ tiến độ, phạm vi kiểm tra và tiêu chuẩn kết thúc:

Điều quan trọng là thông báo cho nhóm dự án biết bao nhiêu kiểm thử đã được thực hiện, kết quả là gì, được đánh giá và kết luận như nào, kết quả có thể nhìn thấy và hữu ích.

Cung cấp thông tin về kiểm thử:

Báo cáo định kỳ và báo cáo đặc biệt cho người quản lý, nhà tài trợ dự án, khách hàng và các bên liên quan chính để giúp họ đưa ra các quyết định về tình hình dự án.

Khởi tạo các hành động khắc phục: ví dụ: thắt chặt các tiêu chuẩn kết thúc đối với các lỗi, sai sót cố định.

Đưa ra quyết định:

Dựa vào các thông tin và báo cáo thu thập được trong quá trình kiểm thử và các rủi ro của dự án mà chúng ta đưa ra quyết định: tiếp tục hay dừng lại, bàn giao phần mềm hoặc giữ lại.

### 1.2. Phân tích và thiết kế kiểm thử (Test analysis and design).

Phân tích và thiết kế kiểm thử là hoạt động mà tại đó các mục tiêu kiểm thử tổng quát được chuyển đổi thành các điều kiện kiểm thử và thiết kế kiểm thử hữu hình.Phân tích và thiết kế kiểm thử có các nhiệm vụ chính sau đây.

Xem xét nền tảng kiểm thử( như là phân tích rủi ro của sản phẩm, các yêu cầu, kiến trúc, thiết kế các chi tiết kỹ thuật và giao diện).

Xác định các điều kiện kiểm thử: dựa trên việc phân tích các item test, các chi tiết kỹ thuật, hành vi và cấu trúc phần mềm.

Thiết kế test case

Đánh giá tính khả thi trong việc kiểm thử của yêu cầu cũng như của hệ thống. -Thiết kế thiết lập môi trường kiểm thử và xác định bất kỳ yêu cầu cơ sở hạ tầng và các công cụ kiểm thử tương ứng.

### 1.3. Thực hiện và Thực thi kiểm thử (Test implementation and execution).

Trong quá trình thực thi và thực hiện kiểm thử, chúng ta đưa ra các điều kiện kiểm thử trong mỗi trường hợp kiểm thử, phần mềm test (testware) và thiết lập môi trường kiểm thử.Thực thi và thực hiện kiểm thử có những nhiệm vụ sau đây:

Thực thi(Implementation):

Phát triển và ưu tiên các testcase bằng cách sử dụng các kỹ thuật trong Chương 4 và tạo dữ liệu cho những kiểm thử đó. Viết hướng dẫn để thực hiện các bài test. ở giai đoạn này Chúng ta có thể cần phải tự động hóa một số kiểm thử sử dụng kịch bản test harnesses và automated test (kiểm thử tự động).

Tạo test suites từ các trường hợp kiểm thử để thực hiện kiểm thử hiệu quả.

Thực hiện và xác minh lại môi trường: đảm bảo rằng môi trường đã được thiết lập chính xác, thậm chí có thể chạy kiểm thử trên đó.

Thực hiện (Execution):

Thực thi test suites và trường hợp kiểm thử riêng lẻ theo các phương thức kiểm thử.

Ghi lại kết quả của việc thực hiện kiểm thử: tên, phiên bản của các testware, công cụ kiểm thử.

So sánh kết quả thực tế với kết quả mong đợi.

Viết báo cáo đối với những trường hợp có sự khác biệt giữa kết quả thực tế và kết quả mong đợi.

Xác nhận kiểm thử hoặc tái kiểm thử: Cần thực hiện lại các kiểm thử mà trước đó đã thất bại để xác nhận lại lỗi đấy đã được sửa chữa hay chưa và đảm bảo không phát sinh lỗi khác.

### 1.4. Đánh giá Tiêu chuẩn kết thúc và báo cáo (Evaluating Exit criteria and reporting).

Dựa trên đánh giá rủi ro của dự án, chúng ta sẽ thiết lập các tiêu chí cho từng hoạt động kiểm thử tương ứng để từ đó có thể xác định được liệu kiểm thử đã đủ hay chưa. Những tiêu chí này khác nhau tùy từng dự án và được gọi tiêu chí kết thúc kiểm thử (exit criteria). Các tiêu chí này bao gồm:

Số lượng test case tối đa được thực thi Passed

Tỷ lệ lỗi giảm xuống dưới mức nhất định

Khi đến deadline.

Việc đánh giá Exit criteria gồm các nhiệm vụ chủ yếu sau:

Kiểm tra test logs với các tiêu chí kết thúc được chỉ định trong quá trình lập kế hoạch:

Xem xét những bằng chứng mà chúng ta đã kiểm thử, những lỗi nào đã được đưa ra, lỗi đã sửa, xác nhận kiểm tra hoặc đang giải quyết.

Từ đó, đánh giá xem liệu có cần phải test thêm hay điều chỉnh các tiêu chí kết thúc kiểm thử trong kế hoạch: Chúng ta cần phải chạy thêm nhiều thử nghiệm nếu không chạy hết tất cả các test như đã thiết kế hoặc không đạt được bản báo cáo tình hình như dự kiến hoặc là rủi ro trong dự án tăng lên.

Viết báo cáo tóm tắt hoạt động kiểm thử cũng như kết quả kiểm thử cho các bên liên quan.

### 1.5. Các hoạt động kết thúc kiểm thử (Test closure activities)

Các hoạt động kiểm thử thường chỉ được kết thức khi các phần mềm được bàn giao cho khách hàng. Ngoài ra, hoạt đông kiểm thử có thể kết thức trong các trường hợp sau:

khi đã thu thập đầy đủ thông tin cần thiết cho việc kiểm thử.

khi dự án bị hủy bỏ.

Khi các mục tiêu chính đã hoàn thành.

Khi việc bảo trì hoặc cập nhật đã hoàn thành.

Các hoạt động kết thúc kiểm thử bao gồm những nhiệm vụ chính sau:

Kiểm tra khách hàng được nhận sản phẩm theo dự kiến từ đầu và đảm bảo rằng tất cả sự cố đã được giải quyết.

Hoàn thiện và lưu trữ phần mềm testware, chẳng hạn như các kịch bản, môi trường thử nghiệm và bất kỳ cơ sở hạ tầng thử nghiệm nào khác để sử dụng lại sau này.

Bàn giao testware cho tổ chức bảo trì sẽ hỗ trợ phần mềm và thực hiện bất kỳ sửa lỗi hoặc thay đổi bảo trì nào, để sử dụng trong kiểm tra xác nhận và kiểm tra hồi quy.

Đánh giá cách kiểm thử và đưa ra bài học cho lần phát hành và các dự án khác trong tương lai.

## 5. Các yếu tố tâm lý học trong kiểm thử

Tính độc lập -Independence: Sự phân chia trách nhiệm khuyến khích hoàn thành mục tiêu kiểm thử.

Đoán lỗi - Error guessing: Một kỹ thuật thiết kế kiểm thử mà các kinh nghiệm của tester được sử dụng để dự đoán những lỗi có thể xuất hiện trong thành phần hoặc hệ thống trong khi test.

Các developer có thể kiểm tra và tìm thấy lỗi trong code của họ nhưng ở một mức độ nhất định của tính độc lập thì tester làm việc hiệu quả hơn trong việc tìm kiếm các lỗi (error) và các thất bại(failed). Một số cấp độ của tính độc lập được định nghĩa từ thấp đến cao như dưới đây:

Các kiểm thử được thiết kế bởi những người viết phần mềm.

Các kiểm thử được thiết kế bởi người khác (ví dụ như đội phát triển).

Các kiểm thử được thiết kế bởi người từ một nhóm tổ chức khác nhau (một đội kiểm thử độc lập) hoặc chuyên gia kiểm thử.

Các kiểm thử được thiết kế bởi người từ một tổ chức hoặc công ty khác nhau.

Để tìm thấy lỗi trong phần mềm đòi hỏi tính tỉ mỉ, chuyên nghiệp, chú ý đến từng chi tiết, giao tiếp tốt với đội phát triển, đoán lỗi dựa trên kinh nghiệm.

Những lỗi(error) và khuyết thiếu(defects) phải được truyền đạt, mô tả rõ ràng, tránh mâu thuẫn giữa tester và các nhà phân tích, người thiết kế và các nhà phát triển.

Test leader và tester cần có kỹ năng giao tiếp tốt để truyền đạt thông tin thực tế về lỗi, tiến độ và rủi ro. Lỗi được tìm thấy và sửa chữa trong thời gian kiểm thử sẽ tiết kiệm thời gian , tiền bạc và giảm thiểu rủi ro.

Một số cách để cải thiện giao tiếp và các mối quan hệ giữa tester và những người khác:

Bắt đầu với sự hợp tác thay vì trận chiến.

Truyền đạt phát hiện lỗi trên sản phẩm một cách trung lập, không chỉ trích người đã tạo ra lỗi.

Cố gắng hiểu người khác cảm thấy thế nào và lý do tại sao họ phản ứng như vậy.

Xác nhận với người kia đã hiểu những gì bạn nói và ngược lại.

Mình vừa giới thiệu với các bạn về quy trình kiểm thử cơ bản của kiểm thử và các yếu tố tâm lý học ảnh hưởng đến kiểm thử. Sang phần sau chúng ta sẽ đi tìm hiểu các mô hình phát triển phần mềm.Link bài viết tiếp theo Kiểm thử phần mềm: Các mô hình phát triển phần mềm.

https://blog.haposoft.com/kiem-thu-phan-mem-kiem-thu-trong-suot-qua-trinh-phat-trien-phan-mem-phan-1/

Kiểm thử phần mềm: Các mô hình phát triển phần mềm.

duongtt

07 September 2018

software testing

Tiếp tục series tóm tắt từ cuốn sách: FOUNDATIONS OF SOFTWARE TESTING ISTQB CERTIFICATION của tác giả Dorothy Graham, Erik van Veenendaal, Isabel Evans và Rex Black và một số kinh nghiệm của cá nhân trong quá trình làm việc nhằm cung cấp cho các bạn một cái nhìn tổng quan về kiểm thử phần mềm và các kiến thức cơ bản về kiểm thử, các kỹ thuật dùng trong kiểm thử và các công cụ hỗ trợ.

Để tiếp nối nội dung từ bài viết Kiểm thử phần mềm: Các nguyên tắc cơ bản (Phần 2), trong bài viết lần này, mình sẽ giới thiệu Các mô hình phát triển phần mềm (Software Development Models).

1. Mô hình thác nước (Waterfall model).

Phân tích mô hình:

Requirement gathering: Thu thập và phân tích yêu cầu được ghi lại vào tài liệu đặc tả yêu cầu trong giai đoạn này.

System Analysis: Phân tích thiết kế hệ thống phần mềm, xác định kiến trúc hệ thống tổng thể của phần mềm.

Coding: Hệ thống được phát triển theo từng unit và được tích hợp trong giai đoạn tiếp theo. Mỗi Unit được phát triển và kiểm thử bởi dev được gọi là Unit Test.

Testing: Cài đặt và kiểm thử phần mềm. Công việc chính của giai đoạn này là kiểm tra và sửa tất cả những lỗi tìm được sao cho phần mềm hoạt động chính xác và đúng theo tài liệu đặc tả yêu cầu.

Implementation: Triển khai hệ thống trong môi trường khách hàng và đưa ra thị trường.

Operations and Maintenance: Bảo trì hệ thống khi có bất kỳ thay đổi nào từ phía khách hàng, người sử dụng.

Ưu điểm:

Dễ sử dụng, dễ tiếp cận, dễ quản lý.

Sản phẩm phát triển theo các giai đoạn được xác định rõ ràng.

Xác nhận ở từng giai đoạn, đảm bảo phát hiện sớm các lỗi.

Nhược điểm:

Ít linh hoạt, phạm vi điều chỉnh hạn chế.

Rất khó để đo lường sự phát triển trong từng giai đoạn.

Mô hình không thích hợp với những dự án dài, đang diễn ra, hay những dự án phức tạp, có nhiều thay đổi về yêu cầu trong vòng đời phát triển.

Khó quay lại khi giai đoạn nào đó đã kết thúc.

2. Mô hình chữ V (V-model).

V-model là một framework để mô tả các hoạt động vòng đời phát triển phần mềm từ các yêu cầu đặc tả đến bảo trì. Mô hình chữ V minh họa các hoạt động kiểm thử (xác nhận và phê duyệt) có thể được tích hợp vào từng giai đoạn của vòng đời phát triển phần mềm như thế nào, kiểm thử xác nhận diễn ra đặc biệt trong giai đoạn đầu.

Mô hình chữ V có 4 mức độ kiểm thử:

Kiểm thử thành phần ( Component testing ).

Kiểm thử tích hợp (integration testing ).

Kiểm thử hệ thống (system testing).

Kiểm thử chấp nhận ( acceptance testing).

Ưu điểm.

Đơn giản dễ sử dụng.

Có hoạt động, kế hoạch cụ thể cho quá trình test.

Tiết kiệm được thời gian, và có cơ hội thành công cao hơn waterfall.

Chủ động trong việc phát hiện bug, sớm tìm ra bug ngay từ những bước đầu.

Nhược điểm:

Khó quản lý kiểm soát rủi ro, rủi ro cao.

Không phải là một mô hình tốt cho các dự án phức tạp và hướng đối tượng.

Mô hình hoạt động không hiệu quả đối với các dự án dài và đang diễn ra.

Không thích hợp cho các dự án có nguy cơ thay đổi yêu cầu trung bình đến cao.

3. Các Chu trình lặp(Iterative life cycles )

Ở mô hình này các quá trình thực hiện được lặp đi lặp lại theo từng giai đoạn, những giai đoạn sau sẽ là cơ sở để hỗ trợ hoàn thiện chức năng được xây dựng từ các giai đoạn trước. Vào cuối mỗi lần lặp của mô hình sẽ tạo ra một phiên bản mới của phần mềm theo đó kiểm thử sẽ phải kiểm thử chức năng mới, kiểm thử hồi quy, kiểm thử tích hợp. Ưu điểm:

Xây dựng và hoàn thiện các bước sản phẩm theo từng bước.

Thời gian làm tài liệu sẽ ít hơn so với thời gian thiết kế.

Một số chức năng làm việc có thể được phát triển nhanh chóng và sớm trong vòng đời.

Ít tốn kém hơn khi thay đổ phạm vi, yêu cầu.

Dễ quản lý rủi ro.

Trong suốt vòng đời, phần mềm được sản xuất sớm để tạo điều kiện cho khách hàng đánh giá và phản hồi.

Nhược điểm:

Yếu cầu tài nguyên nhiều.

Các vấn đề về thiết kế hoặc kiến trúc hệ thống có thể phát sinh bất cứ lúc nào.

Yêu cầu quản lý phức tạp hơn.

Tiến độ của dự án phụ thuộc nhiều vào giai đoạn phân tích rủi ro.

4. Mô hình gia tăng (Incremental model)

Mô hình gia tăng là sự kết hợp của 1 hoặc nhiều mô hình thác nước. Trong mô hình này các yêu cầu được chia thành nhiều mô đun và mỗi mô đun được phát triển riêng biệt, cuối cùng tích hợp các mô đun đã phát triển trở thành một hệ thống hoàn chỉnh.

Ưu điểm:

Phát triển nhanh chóng, sau khi hoàn thành 1 mô đun là có thể chuyển giao cho khách hàng.

Mô hình này linh hoạt hơn, ít tốn kém hơn khi thay đổi phạm vi và yêu cầu.

Dễ dàng hơn trong việc kiểm tra và sửa lỗi.

Nhược điểm:

Cần lập kế hoạch và thiết kế tốt.

Tổng chi phí là cao hơn so với mô hình thác nước.

5. Mô hình RAD (Rapid Application Development)

Mô hình RAD là một phương pháp phát triển phần mềm sử dụng quy hoạch tối thiểu có lợi cho việc tạo mẫu nhanh. Các mô đun chức năng được phát triển song song và được tích hợp để tạo ra sản phẩm hoàn chỉnh để phân phối sản phẩm nhanh hơn.

Ưu điểm:

Cho phép xác định sớm rủi ro công nghệ.

Đáp ứng nhanh chóng với sự thay đổi yêu cầu của khách hàng.

Giảm được thời gian phát triển của sản phẩm.

Sớm đưa ra được những đánh giá, nhận xét, phản hồi từ khách hàng nên dễ dàng điều chỉnh.

Nhược điểm:

Chỉ áp dụng mô hình RAD khi dự án có thời gian gấp rút từ 2 đến 3 tháng.

Chỉ được sử dụng khi thiết kế có sẵn các module.

Các yêu cầu dự án rõ ràng.

Có đủ nguồn lực cả về công cụ, con người, tài liệu, phần mềm hỗ trợ.

Tốn chi phí khi xây dựng nhiều team phát triển song song.

6. Mô hình Agile.

Mô hình Agile phát triển dựa vào mô hình lặp (Iterative life cycles) và gia tăng (Incremental model)tập trung vào khả năng thích ứng của quy trình và sự hài lòng của khách hàng bằng cách phân phối nhanh sản phẩm phần mềm.Trong mô hình này:

Hệ thống được chia thành các mô đun nhỏ, mỗi lần lặp liên quan đến các quy trình: lập kế hoạch, phân tích yêu cầu, thiết kế, code, kiểm thử.

Vào cuối mỗi vòng lặp sẽ hoàn thành được một module hoặc chức năng và có thể đưa cho khách hàng đánh giá và phản hồi.

Ưu điểm:

Đạt được sự hài lòng của khách hàng bằng cách bàn giao nhanh chóng, liên tục các sản phẩm phần mềm có ích.

Con người và tương tác được nhấn mạnh hơn là quá trình và công cụ. Khách hàng, nhà phát triển và người thử nghiệm liên tục trao đổi với nhau.

Phần mềm làm việc được bàn giao thường xuyên (vài tuần chứ không phải vài tháng).

Cuộc đối thoại trực tiếp (face-to-face) là hình thức giao tiếp tốt nhất.

Gần gũi với nhau hơn, hợp tác hàng ngày giữa các khách hàng và các lập trình viên.

Chú ý liên tục về kỹ thuật và bản thiết kế tốt.

Thường xuyên thích nghi với hoàn cảnh thay đổi. -Ngay cả những thay đổi muộn trong yêu cầu cũng được hoan nghênh.

Nhược điểm:

Không thích hợp để xử lý các phụ thuộc phức tạp.

Có nhiều rủi ro về tính bền vững, khả năng bảo trì và khả năng mở rộng.

Cần một team có kinh nghiệm.

Phụ thuộc rất nhiều vào sự tương tác rõ ràng của khách hàng.

Chuyển giao công nghệ cho các thành viên mới trong nhóm có thể khá khó khăn do thiếu tài liệu.

Kết thúc phần này, các bạn có thể hiểu được các mô hình được sử dụng trong một vòng đời phát triển của phần mềm, ưu điểm, nhược điểm và phạm vi áp dụng của từng mô hình.

Sang bài viết tiếp theo mình sẽ giới thiệu 4 mức kiểm thử: kiểm thử thành phần, kiểm thử tích hợp, kiểm thử hệ thống và kiểm thử chấp nhận.Link bài viết tiếp theo Kiểm thử phần mềm: Các mức kiểm thử (Test levels)

https://blog.haposoft.com/kiem-thu-phan-mem-cac-muc-kiem-thu/

Kiểm thử phần mềm: Các mức kiểm thử (Test levels)

duongtt

10 September 2018

software testing

Tiếp tục series tóm tắt từ cuốn sách: FOUNDATIONS OF SOFTWARE TESTING ISTQB CERTIFICATION của tác giả Dorothy Graham, Erik van Veenendaal, Isabel Evans và Rex Black và một số kinh nghiệm của cá nhân trong quá trình làm việc nhằm cung cấp cho các bạn một cái nhìn tổng quan về kiểm thử phần mềm và các kiến thức cơ bản về kiểm thử, các kỹ thuật dùng trong kiểm thử và các công cụ hỗ trợ.

Để tiếp nối nội dung từ bài viết Kiểm thử phần mềm: Các mô hình phát triển phần mềm. Bài viết hôm nay mình sẽ giới thiệu với các bạn 4 mức kiểm thử: kiểm thử thành phần, kiểm thử tích hợp, kiểm thử hệ thống và kiểm thử chấp nhận.

1. Kiểm thử thành phần (Component testing).

Cơ sở kiểm thử:

Các yêu cầu thành phần.

Thiết kế chi tiết.

Code.

Đối tượng kiểm thử:

Các thành phần (các hàm (Function), thủ tục (Procedure), lớp (Class), hoặc các phương thức (Method), các đối tượng (objects)...).

Các module, chương trình.

Chuyển đổi dữ liệu thay đổi chương trình.

Mô hình cơ sở dữ liệu:

Kiểm thử thành phần ( còn gọi là kiểm thử đơn vị, module, chương trình) tìm kiếm các lỗi và các chức năng, module phần mềm, chương trình, đối tượng, các lớp(class)... có thể được thực hiện biệt lập với phần còn lại của hệ thống, phụ thuộc vào vòng đời phát triển và hệ thống..

Hầu hết các stub và driver được sử dụng để thay thế sự khuyết thiếu của phần mềm và mô phỏng giao diện giữa các thành phần phần mềm một cách đơn giản.

Stub là một chương trình hoặc thành phần giả lập (thay thế cho chương trình hoặc thành phần chưa code xong để kiểm thử)

Driver là một thành phần của phần mềm hoặc công cụ kiểm thử thay thế cho một thành phần mà sẽ điều khiển hoặc gọi đến một thành phần hoặc hệ thống khác.

Kiểm thử thành phần bao gồm:

Kiểm thử chức năng và phi chức năng.

Các trường hợp kiểm thử bắt nguồn từ các đặc điểm kỹ thuật của thành phần, thiết kế phần mềm hoặc các mô hình dữ liệu .

Kiểm thử thành phần thực hiện khi truy cập vào code . Người thực hiện kiểm thử là lập trình viên viết code.

2. Kiểm thử tích hợp (Integration testing)

Cơ sở kiểm thử:

Thiết kế hệ thống và phần mềm.

Kiến trúc.

Luồng công việc (Workflows).

Các trường hợp sử dụng (use case).

Đối tượng kiểm thử:

Triển khai cơ sở dữ liệu các hệ thống con.

Cơ sở hạ tầng ( Infrastructure).

Giao diện.

Cấu hình hệ thống - cấu hình dữ liệu.

Kiểm thử tích hợp kiểm thử giao diện giữa các thành phần, tương tác với các thành phần khác nhau của hệ thống như hệ điều hành, hệ thống tài liệu, phần cứng hoặc là giao diện giữa các hệ thống.

Có nhiều hơn một mức kiểm thử tích hợp:

Kiểm thử tích hợp thành phần là kiểm tra sự tương tác giữa các thành phần phần mềm và được thực hiện sau kiểm thử thành phần.

Kiểm thử tích hợp hệ thống kiểm tra sự tương tác giữa các hệ thống khác nhau và có thể được thực hiện sau kiểm thử hệ thống.

Có 4 loại kiểm thử trong kiểm thử tích hợp:

Kiểm thử dựa vào cấu trúc (structure) như là Top-down và Bottom-up.

Kiểm thử chức năng (functional).

Kiểm tra hiệu năng (performance): Kiểm tra việc vận hành của hệ thống.

Kiểm tra khả năng chịu tải (stress): kiểm tra giới hạn của hệ thống.

3. Kiểm thử hệ thống(System testing).

Cơ sở kiểm thử.

Chi tiết yêu cầu của hệ thống và phần mềm.

Các trường hợp sử dụng ( use cases).

Chi tiết các chức năng.

Báo cáo phân tích rủi ro.

Đối tượng kiểm thử:

Hệ thống, người dùng và hướng dẫn cách hoạt động.

Cấu hình hệ thống.

Kiểm thử hệ thống bao gồm các loại kiểm thử sau:

Kiểm thử chức năng (Functional Test): bảo đảm các hành vi của hệ thống thỏa mãn đúng yêu cầu thiết kế.

Kiểm thử hiệu năng (Performance Test): bảo đảm tối ưu việc phân bổ tài nguyên hệ thống (ví dụ bộ nhớ) nhằm đạt các chỉ tiêu như thời gian xử lý hay đáp ứng câu truy vấn…

Kiểm thử khả năng chịu tải (Stress Test hay Load Test): bảo đảm hệ thống vận hành đúng dưới áp lực cao. Stress Test tập trung vào các trạng thái tới hạn, các tình huống bất thường…

Kiểm thử cấu hình (Configuration Test)

Kiểm thử khả năng bảo mật (Security Test): bảo đảm tính toàn vẹn, bảo mật của dữ liệu và của hệ thống.

Kiểm thử khả năng phục hồi (Recovery Test): bảo đảm hệ thống có khả năng khôi phục trạng thái ổn định trước đó trong tình huống mất tài nguyên hoặc dữ liệu.

4. Kiểm thử chấp nhận (Acceptance testing).

Cơ sở kiểm thử:

Yêu cầu người dùng.

Yêu cầu hệ thống.

Các trường hợp sử dụng (Use cases).

Các quy trình nghiệp vụ.

Báo cáo phân tích rủi ro.

Đối tượng kiểm thử:

Các quy trình nghiệp vụ trên hệ thống đã được tích hợp đầy đủ.

Các quy trình vận hành và bảo trì.

Các phương thức người dùng ( User procedures).

Các Forms.

Các báo cáo.

Kiểm thử chấp nhận là trách nhiệm của khách hàng và người dùng hệ thống, Mục tiêu của kiểm thử chấp nhận là tạo sự tin cậy trong hệ thống, các bộ phận của hệ thống hoặc các đặc tính phi chức năng của hệ thống.

Kiểm thử chấp nhận có thể xảy ra vào các thời điểm khác nhau trong vòng đời phát triển phần mềm:

Một sản phẩm phần mềm thương mại (COTS-Commercial Off The Shelf ) có thể kiểm thử chấp nhận khi được cài đặt hoặc tích hợp.

Kiểm thử chấp nhận kiểm tra tính tiện ích của một thành phần có thể được thực hiện trong quá trình kiểm thử thành phần.

Kiểm thử chấp nhận của một chức năng mới có thể thực hiện trước khi kiểm thử hệ thống.

Trong kiểm thử chấp nhận có 2 loại kiểm thử chính, do tính đặc biệt của chúng, chúng được chuẩn bị và thực hiện riêng biệt.

Alpha testing: Là việc kiểm thử hoạt động chức năng thực tế hoặc giả lập do người dùng/khách hàng tiềm năng hoặc một nhóm test độc lập thực hiện tại nơi sản xuất phần mềm. Alpha test là một hình thức kiểm thử chấp nhận nội bộ trước khi phần mềm được tiến hành kiểm thử beta.

Beta testing (hoặc thử nghiệm thực địa) : Được thực hiện sau alpha testing. Gửi hệ thống tới một số người dùng - là người cài đặt và sử dụng nó trong điều kiện làm việc thực tế. Người dùng gửi báo cáo về các sự cố, lỗi của hệ thống đến các tổ chức phát triển nơi mà các lỗi được sửa chữa.

Mình vừa giới thiệu đến một số loại kiểm thử phần mềm phổ biến mà kỹ sư kiểm thử thường thực thi. Ngoài những loại kiểm thử kể trên, còn một số loại kiểm thử khác nhưng vì chúng không được phổ biến nên mình tạm thời không giới thiệu trong bài viết này. Ở bài viết tiếp theo mình sẽ giới thiệu với các bạn các loại kiểm thử (Test types).

https://blog.haposoft.com/kiem-thu-phan-mem-cac-loai-kiem-thu/

Kiểm thử phần mềm: Các loại kiểm thử (Test types) và kiểm thử bảo trì

duongtt

14 September 2018

software testing

Tiếp tục series tóm tắt từ cuốn sách: FOUNDATIONS OF SOFTWARE TESTING ISTQB CERTIFICATION của tác giả Dorothy Graham, Erik van Veenendaal, Isabel Evans và Rex Black và một số kinh nghiệm của cá nhân trong quá trình làm việc nhằm cung cấp cho các bạn một cái nhìn tổng quan về kiểm thử phần mềm và các kiến thức cơ bản về kiểm thử, các kỹ thuật dùng trong kiểm thử và các công cụ hỗ trợ.

Ở bài viết trước mình đã giới thiệu với các bạn một số loại kiểm thử phần mềm phổ biến mà kỹ sư kiểm thử thường thực thi Kiểm thử phần mềm: Các mức kiểm thử (Test levels). Để tiếp nối Chương 2 trong tài liệu FOUNDATIONS OF SOFTWARE TESTING bài viết lần này mình sẽ giới thiệu Các loại kiểm thử (Test types) và kiểm thử bảo trì (Maintenance Testing) trong kiểm thử phần mềm.

1. Kiểm thử chức năng (functional testing).

Kiểm thử chức năng là một loại kiểm thử hộp đen (black box) và test case của nó được dựa trên đặc tả của ứng dụng phần mềm/thành phần đang test. Các chức năng được test bằng cách nhập vào các giá trị và kiểm tra kết quả đầu ra, ít quan tâm đến cấu trúc bên trong của ứng dụng.

Kiểm thử chức năng có thể được thực hiện từ 2 góc nhìn: dựa trên yêu cầu và dựa trên quy trình nghiệp vụ.

Dựa trên yêu cầu:

Sử dụng các đặc tả kỹ thuật của các yêu cầu chức năng để làm cơ sở cho việc test các thiết kế.

Nội dung của các yêu cầu có thể làm các mục kiểm thử ban đầu hoặc sử dụng nó như là một danh sách các mục kiểm thử hoặc không kiểm thử.

Dựa theo yêu cầu để phân mức độ ưu tiên trong quá trình kiểm thử. Cần ưu tiên các yêu cầu có mức độ rủi ro cao.

Dựa trên quy trình nghiệp vụ:

Các quy trình nghiệp vụ mô tả các kịch bản scenarios liên quan đến các nghiệp vụ hằng ngày của hệ thống

các usecase được bắt nguồn phát triển theo hướng đối tượng nhưng hiện tại phổ biến trong nhiều trong các vòng đời phát triển.

Lấy các quy trình nghiệp vụ làm điểm khởi đầu, các quy trình nghiệp vụ xuất phát từ các nhiệm vụ được thực hiện bởi người dùng.

Các use case là một cơ sở hữu ích cho các testcase từ góc độ nghiệp vụ.

Kiểm thử chức năng bao gồm 5 bước:

Xác định các chức năng mà phần mềm mong muốn sẽ thực hiện.

Tạo ra các dữ liệu đầu vào dựa trên các tài liệu đặc tả kỹ thuật của các chức năng.

Xác định kết quả đầu ra dựa trên các tài liệu đặc tả kỹ thuật của các chức năng.

Thực hiện các trường hợp kiểm thử.

So sánh kết quả thực tế và kết quả mong muốn.

Các loại kiểm thử chức năng:

Kiểm thử đơn vị (Unit Testing)

Kiểm thử khói (Smoke Testing - check nhanh xem hệ thống có khởi động được hay không)

Kiểm thử độ tỉnh táo (Sanity Testing - check nhanh xem sau khi sửa đổi thì function có hoạt động như mong muốn hay không)

Kiểm thử giao diện (Interface Testing)

Kiểm thử tích hợp (Integration Testing)

Kiểm thử hệ thống (Systems Testing)

Kiểm thử hồi quy (Regression Testing)

Kiểm thử chấp nhận (Acceptance testing)

2. Kiểm thử phi chức năng (non-functional testing).

Kiểm thử phi chức năng cùng giống kiểm thử chức năng ở chỗ là thực hiện được ở mọi cấp độ kiểm thử,Kiểm thử phi chức năng xem xét các hành vi bên ngoài của phần mềm . Kiểm thử phi chức năng bao gồm:

Kiểm thử hiệu năng (performance testing).

Kiểm thử khả năng chịu tải (load testing).

Kiểm thử áp lực(stress testing).

Kiểm thử khả năng sử dụng (usability testing).

Kiểm thử bảo trì (maintainability testing).

Kiểm thử độ tin cậy (reliability testing)

Kiểm thử tính tương thích(portability testing)

Những đặc điểm phụ tương ứng:

Độ tin cậy (reliability): được xác định rõ hơn từ các đặc trưng phụ đã được tính toán cẩn thận(độ bền), khả năng chịu lỗi(fault tolerance), phục hồi (recoverability) và tuân thủ (compliance).

Khả năng sử dụng (usability): được chia thành các đặc trưng dễ hiểu, khả năng học hỏi (learnability), khả năng hoạt động (operability), sự thu hút (attractiveness) và tính tuân thủ (compliance).

Tính hiệu quả (efficiency): được chia thành hành vi về thời gian(hiệu suất), sử dụng tài nguyên (resource utilization) và tuân thủ (compliance).

Khả năng bảo trì (maintainability): bao gồm 5 đặc điểm phụ: phân tích, khả năng thay đổi, tính ổn định, khả năng kiểm tra và tuân thủ.

Tính tương thích (portability): bao gồm 5 đặc điểm phụ: khả năng thích ứng, khả năng cài đặt, cùng tồn tại, khả năng thay thế và tuân thủ.

3. Kiểm thử cấu trúc/kiến trúc phần mềm(structural testing).

Kiểm thử cấu trúc có thể xảy ra ở bất kỳ mức độ kiểm thử nào, được áp dụng chủ yếu ở kiểm thử thành phần, tích hợp.

Phương pháp kiểm thử cấu trúc cũng có thể áp dụng ở các mức độ như kiểm thử tích hợp hệ thống hoặc kiểm thử chấp nhận.

Kỹ thuật kiểm thử cấu trúc được sử dụng tốt nhất sau các kỹ thuật dựa trên các đặc điểm kỹ thuật( specification-based). Giúp đo lường kỹ lưỡng kiểm thử thông qua đánh giá độ bao phủ của loại cấu trúc.

Độ bao phủ là phạm vi mà một cấu trúc đã được thực hiện bởi một bộ kiểm thử, tính theo phần trăm của các mục đã được bao phủ. Nếu độ bao phủ không phải là 100% các kiểm thử sẽ được thiết kế để kiểm tra các mục đã bị bỏ lỡ để tăng độ bao phủ.

Các ký thuật được sử dụng để kiểm thử cấu trúc là: các kỹ thuật hộp trắng và các mô hình luồng điều khiển(Control flow models).

4. Kiểm thử xác nhận(confirmation testing) và kiểm thử hồi quy(regression testing)

Kiểm thử xác nhận.

Sau khi một lỗi được phát hiện và sửa chữa, phần mềm được kiểm thử lại để xác nhận lỗi ban đầu đã được khắc phục gọi là kiểm thử xác nhận (Confirmation testing).

Khi thực hiện kiểm thử xác nhận phải đảm bảo rằng các thử nghiệm được thực hiện giống như lần đầu tiên sử dụng, sử dụng các inputs, dữ liệu và môi trường giống nhau.

Kiểm thử hồi quy:

Mục đích của kiểm thử hồi quy là xác minh rằng sửa đổi trong phần mềm hoặc môi trường không gây ra các phản ứng phụ không mong muốn và hệ thống vẫn đáp ứng các yêu cầu.

Kiểm thử hồi quy là các kiểm thử lặp đi lặp lại của một chương trình đã được kiểm thử, sau khi sửa đổi.

Kiểm thử hồi quy được thực hiện bất cứ khi nào trong phần mềm hoặc là kết quả của các bản sửa lỗi, chức năng mới được thay đổi

Kiểm thử hồi quy dựa vào các bộ test case. Khi thêm chức năng mới thì phải thêm các testcase mới hoặc là các chức năng cũ được thay đổi hay xóa bỏ thì test case cũng phải được thay đổi hoặc xóa bỏ.

Kiểm thử hồi quy có thể được thực hiện tại tất cả mức độ kiểm thử , bao gồm kiểm thử chức năng, phi chức năng và kiểm thử cấu trúc.

5. Kiểm thử bảo trì (Maintenance testing).

Phân tích tác động và kiểm thử hồi quy:

Thông thường kiểm thử bảo trì gồm 2 phần: kiểm thử các thay đổi và Kiểm thử hồi quy để cho thấy phần còn lại của hệ thống không bị ảnh hưởng bởi công việc bảo trì.

Hoạt động chính và quan trọng trong việc kiểm thử bảo trì là việc phân tích các tác động. Từ việc phân tích sẽ quyết định được những phần nào của hệ thống có thể bị ảnh hưởng không mong muốn.

Phân tích rủi ro sẽ giúp quyết định được nơi cần tập trung kiểm thử hồi quy.

Khởi động cho kiểm thử bảo trì:

Kiểm thử bảo trì được thực hiện trên hệ thống đã tồn tại và được thực hiện khi có sự thay đổi, di chuyển hoặc rút lui của phần mềm hoặc hệ thống.

Kiểm thử bảo trì cho việc thay đổi: Các cải tiến bao gồm thay đổi tăng theo kế hoạch, khắc phục những thay đổi khẩn cấp và thay đổi môi trường.

Kiểm thử bảo trì cho sự chuyển đổi: Bao gồm kiểm tra hoạt động của môi trường mới , các phần mềm đã thay đổi. Kiểm thử di chuyển ( kiểm thử chuyển đổi) cũng cần thiết khi dữ liệu từ một ứng dụng khác sẽ được di chuyển vào hệ thống đang được bảo trì.

Kiểm thử bảo trì đối với hệ thống đã ngưng hoạt động: bao gồm kiểm thử việc chuyển đổi dữ liệu hoặc lưu trữ, nếu cần lưu trữ dữ liệu lâu dài.

Từ quan điểm của việc chuyển đổi thì có 2 loại:

Chuyển đổi theo kế hoạch bao gồm: Chuyển đổi hoàn thiện(phần mềm thích nghi được với mong muốn người dùng), Chuyển đổi thích nghi ( phần mềm thích nghi được với sự thay đổi của môi trường như phần cứng mới, phần mềm hệ thống mới), Chuyển đổi điều chỉnh theo kế hoạch ( sửa chữa lỗi).

Những chuyển đổi bột phát không thể lên kế hoạch được: đối với những lỗi như thế này cần phân tích rủi ro của hệ thống hoạt động để xác định chức năng hoặc chương trình gây lỗi.

Kết thúc bài viết lần này các bạn có thể nắm được những thông tin cơ bản về 4 loại kiểm thử chính ( chức năng, phi chức năng, cấu trúc và các thay đổi có liên quan) và kiểm thử bảo trì.Link bài viết tiếp theo Kiểm thử phần mềm: Các kỹ thuật tĩnh (Static techniques)

https://blog.haposoft.com/kiem-thu-phan-mem-static-technique/

# Kiểm thử phần mềm: Các kỹ thuật tĩnh (Static techniques)

###### Nguyễn Xuân Lâm

17 September 2018

software testing

Tiếp tục series tóm tắt từ cuốn sách: FOUNDATIONS OF SOFTWARE TESTING ISTQB CERTIFICATION của tác giả Dorothy Graham, Erik van Veenendaal, Isabel Evans và Rex Black và một số kinh nghiệm của cá nhân trong quá trình làm việc nhằm cung cấp cho các bạn một cái nhìn tổng quan về kiểm thử phần mềm và các kiến thức cơ bản về kiểm thử, các kỹ thuật dùng trong kiểm thử và các công cụ hỗ trợ.

Để tiếp nối nội dung từ bài viết Kiểm thử phần mềm: Các loại kiểm thử (Test types) và kiểm thử bảo trì , trong bài viết lần này, mình sẽ giới thiệu Các kỹ thuật tĩnh (Static techniques)

Kĩ thuật kiểm thử tĩnh (Static testing) cung cấp một phương pháp để cải thiện chất lượng và năng suất của quá trình phát triển phần mềm. Mục đích cốt lõi của kiểm thử tĩnh là để cải thiện chất lượng sản phẩm bằng cách trợ giúp các kĩ sư sớm nhận biết và sửa chữa những lỗi sai của chính họ ngay từ những giai đoạn đầu tiên trong quá trình phát triển phần mềm. Mặc dù kiểm thử tĩnh không giải quyết được hết tất cả các vấn đề nhưng nó có hiệu quả to lớn nhờ có có những yếu tố cấu thành khá ấn tượng. Kiểm thử tĩnh không phải một "phép màu" và nó cũng không thể được xem là một phương pháp thay thế cho Kiểm thử động (Dynamic testing), nhưng tất cả các tổ chức liên quan tới phát triển phần mềm nên coi việc sử dụng kĩ thuật rà soát đánh giá (review) cho tất cả những thành phần chính trong công việc của họ bao gồm yêu cầu (requirements), thiết kế (design), thực hiện (implementation), kiểm thử (testing) và bảo trì (maintenance).

Qua chương 1 và chương 2, chúng ta đã biết mục đích của kiểm thử là: đánh giá, tìm ra những lỗi sai và chất lượng sản phẩm. Kiểm thử chia thành 2 loại: Kiểm thử tĩnh (Static) và kiểm thử động (Dynamic).

## I. Khái niệm, phân loại

### 1. Khái niệm

Kiểm thử tĩnh là một hình thức của kiểm thử phần mềm mà không thực hiện phần mềm. Điều này ngược với thử nghiệm động. Thường thì nó không kiểm thử chi tiết mà chủ yếu kiểm tra tính đúng đắn của code (mã lệnh), thuật toán hay tài liệu.

Chủ yếu là kiểm tra cú pháp của code và/hoặc review code (kiểm tra xem code có được viết theo đúng tiêu chuẩn code. Ví dụ cách đặt tên hàm tên biến, cách sử dụng hàm chung đã đưa ra hay chưa) hoặc tài liệu để tìm lỗi bằng cách thủ công. Đây là loại kiểm thử được thực hiện bởi DEV (những người lập trình), làm việc một cách độc lập.

Lỗi được phát hiện ở giai đoạn phát triển này là ít tốn kém để sửa chữa hơn so với lỗi phát hiện được ở các giai đoạn sau này trong các quy trình phát triển phần mềm.

### 2. Phân loại

Đánh giá thủ công (Review manually)

Dùng công cụ hỗ trợ (Automated Analysis by Tool).

## II. Đánh giá (Review)

### 1. Quy trình

Quy trình Formal review sẽ có 6 bước:

Lập kế hoạch - Planning

Bắt đầu - Kick-off

Chuẩn bị - Preparation

Họp đánh giá - Review meeting

Làm lại - Rework

Follow-up

Giai đoạn 1: Lập kế hoạch

Đây là giai đoạn đầu tiên, quan trọng của quá trình kiểm tra. Ở giai đoạn đầu tiên, chúng ta cần thực hiện các hành động sau:

Xác định tiêu chuẩn review

Chọn nhận sự

Phân bổ vai trò cho từng người

Xác định tiêu chuẩn đầu ra và đầu vào cho các loại formal review( vd: inspections)

Chọn các phần của document để review

Kiểm tra tiêu chuẩn đầu vào

Giai đoạn 2: Bắt đầu

Mục đích của việc thực hiện buổi họp là để thống nhất quan điểm về tài liệu và thời gian tiến hành.

Các mối quan hệ giữa tài liệu được review và tài liệu nguồn (source) sẽ được giải thích, đặc biệt khi con số tài liệu liên quan lại lớn.

Có thể đưa ra thảo luận việc phân chia vai trò, tốc độ kiểm tra, phạm vi kiểm tra, quy trình và những câu hỏi khác ...

Giai đoạn 3: Chuẩn bị

Những người tham gia review sẽ làm việc biệt lập với nhau sử dụng những tài liệu, quy trình, quy định và checklist liên quan. Người review chịu trách nhiệm phát hiện defect sau đó đặt câu hỏi hay nhận xét dựa trên những hiểu biết cuả bản thân và theo đúng nhiệm vụ. Tất cả các vấn đề được nêu ra đều được ghi chép lại sử dụng các biểu mẫu khai báo. Những lỗi chính tả cũng sẽ được ghi lại trong tài liệu nhưng sẽ không được nhắc đến trong buổi họp.

Số lượng trang cần kiểm tra mỗi giờ chỉ nên ở khoảng 5-10 trang/giờ.

Nên sử dụng checklist trong giai đoạn này giúp việc review trở nên hiệu quả và đầy đủ hơn.

Giai đoạn 4: Họp đánh giá

Buổi họp bao gồm những phần sau: giai đoạn khai thác thông tin, giai đoạn thảo luận và giai đoạn đưa raquyết định.

Giai đoạn khai thác thông tin: Chuẩn bị (Xác định) các lỗi sẽ đưa ra thảo luận. Lưu ý không thảo luận trong giai đoạn này. và ghi chép lại các lỗi đó

Giai đoạn thảo luận: Thảo luận các lỗi đã đưa ra ở giai đoạn khai thác thông tin: liệu một vấn đề nào đó có phải là lỗi (defect) hay không? Đánh giá mức độ nghiêm trọng của lỗi...

Giai đoạn đưa ra quyết định: những người tham gia phải đưa ra quyết định về tài liệu đang được đánh giá.

Giai đoạn 5: Làm lại

Dựa trên kết quả của những defect đã được tìm ra, tác giả sẽ dần dần từng bước chỉnh sửa cập nhật tài liệu.

Những thay đổi được thực hiện trên tài liệu nên được xác định tại bước follow-up. Vì vậy, tác giả cần trình bày chỉ ra nơi những thay đổi đã được thực hiện. Ví dụ sử dụng các chức năng “Track changes” của các phần mềm xử lí văn bản.

Giai đoạn 6: Follow-up

Kiểm tra đảm bảo rằng tác giả đã thực hiện thay đổi trên tất cả các lỗi được báo cáo

Thu thập một số các số liệu đo lường tại mỗi bước của quy trình để kiểm soát và tối ưu quy trình review

### 2. Vai trò, trách nhiệm của các thành phần tham gia review

Moderator: Dẫn dắt/điều phối các buổi họp review, thực hiện các task: lên kế hoạch, thực hiện họp, follow sau khi họp để đảm bảo kiểm soát chất lượng đầu vào đầu ra của quy trình đánh giá. Ngoài ra, Moderator sẽ sắp xếp các cuộc họp, phổ biến tài liệu trước khi họp, đào tạo các thành viên khác trong nhóm, và lưu trữ dữ liệu được thu thập.

Tác giả (Author): là người viết tài liệu. Tác giả có trách nhiệm chỉnh sửa các lỗi tìm được trong tài liệu, luôn tìm hiểu để nâng cao chất lượng tài liệu

Người đánh giá (Reviewers): là các cá nhân có kiến thức về kỹ thuật hoặc nghiệp vụ, tham gia vào chuẩn bị, xác định và mô tả lỗi. (Nên chọn người đánh giá ở các vai trò khác nhau)

Người viết (Scribe hay recorder): là người ghi chép lại tất cả các issues, vấn đề, điểm mở trong từng buổi review, từng giai đoạn review. Việc sử dụng checklist hoặc xem các sản phẩm có liên quan giúp review hiệu quả hơn, phát hiện nhiều lỗi hơn.

Các nhà lãnh đạo (Manager): Là người quyết định có thực hiện review hay không, phân bổ thời gian trong lịch trình của dự án và xác định mục tiêu của quy trình đánh giá đã được đá ứng hay chưa, quan tâm đến các buổi đào tạo mà người tham gia yêu cầu.

### 3. Các yếu tố ảnh hưởng đến sự thành công của các quy trình đánh giá

Tìm được Moderator có thể dẫn dắt tất cả các giai đoạn của dự án, Moderator cần có chuyên môn, sự nhiệt tình và tư duy thực tế để hướng dẫn, dẫn dắt người tham gia, quyền hạn của Moderator phải rõ ràng

Khi tổ chức review phải có mục đích rõ ràng

Mời đúng những người cần tham gia vào review

Tester là người rất có giá trị khi tham gia vào review

Không cố giấu các lỗi được tìm thấy

Vấn đề rắc rối về con người và khía cạnh tâm lý cần được giải quyết

Review được thực hiện trong bầu không khí tin tưởng, kết quả của nó không được dùng để đánh giá những người tham gia.

Các kỹ thuật review được dung phù hợp để đạt được mục đích

Checklist hoặc vai trò được sử dụng nếu phù hợp sẽ tăng hiệu quả tìm ra lỗi

Cần thực hiện đào tạo về kỹ thuật review đặc biệt là các kỹ thuật chính thống như inspection

Sự hỗ trợ của lãnh đạo rất quan trọng để có quy trình review tốt (bố trí đủ thời gian cho hoạt động review trong dự án) Nhấn mạnh vào việc học và cải tiến quy trình

### 4. Phân loại đánh giá

Informal review

Informal review là quá trình đánh giá mà không cần hồ sơ cuộc họp đang lưu trữ, cũng không cần ghi chép lại nội dung cuộc họp. Nó được thực hiện ở bất cứ 1 tài liệu nào.

Informal review chủ yếu được thực hiện giữa 2 người ở bất kỳ đâu có thể là quán cà phê, căng-ten,...

Lợi ích mà informal review mang lại:

Không tốn kém

Tiết kiệm thời gian

Không yêu cầu đào tạo người tham gia

Không cần tài liệu hay lưu trữ hồ sơ

Hướng dẫn (Walkthrough)

Tác giả hướng dẫn, giải thích (chuyển giao kiến thức) với những người tham gia thông qua tài liệu và thông qua quá trình tư duy của họ để đạt được một sự hiểu biết chung và thu thập phản hồi liên quan đến chủ đề theo tài liệu.

Các cuộc họp do các tác giả hướng dẫn, thường có người ghi chép riêng.

Các kịch bản và chạy thử có thể được dùng để xác nhận nội dung.

Việc chuẩn bị cuộc họp sẵn riêng cho người đánh giá là không bắt buộc.

Đánh giá kỹ thuật (Technical Review)

Đánh giá kỹ thuật là một cuộc thảo luận tập trung vào việc đạt được sự đồng thuận nội dung kỹ thuật của một tài liệu.

Được dẫn dắt bởi moderator hoặc người có kiến thức kỹ thuật với sự tham gia của các chuyên gia như: Thiết kế, người dùng chính...

Cần chuẩn bị một Review Report bao gồm: danh sách các phát hiện defect, cách giải quyết...

Mục đích chính: thảo luận, đưa ra quyết định, đánh giá sự thay thế, tìm defect, giải quyết vấn đề kỹ thuật và kiểm tra sự phù hợp của spec, plan, regulation và standards

Kiểm tra (Inspection)

Được điều hành bởi moderator

Sử dụng để xác định các vai trò trong quy trình.

Xác định vai trò của từng người

Xác định các tiêu chuẩn đầu vào và ra cho của sản phẩm phần mềm

Cần có báo cáo kiểm tra bao gồm danh sách của các phát hiện defect,..

Có Quy trình follow- up

Mục đích chính: tìm kiếm defects

Các số liệu được tập hợp và phân tích để tối ưu hóa quy trình

## II. Phân tích tĩnh bằng công cụ

Mục tiêu của static analysis by tool là để tìm ra lỗi trong code và mô hình phát triển phần mềm

Static analysis được hiện bằng tool và không cần chạy code, chỉ ra các lỗi mà khó tìm được trong dynamic testing

Giống nhw review , Static analysis tìm ra defects hơn là failures, dựa trên phân tích code (control flow, data flow)

Giá trị của Static Analysis:

Sớm phát hiện được defect trước khi chạy test

Cảnh báo sớm về những khía cạnh đáng ngờ của code hoặc thiết kế bằng các tính toán số liệu, chẳng hạn như một độ đo sư phức tạp cao

Xác định các defects không dễ dàng tìm được bởi dynamic testing

Phát hiện phụ thuộc và không nhất quán trong các mô hình phần mềm như các links

Cải thiện khả năng bảo trì của code và thiết kế

Ngăn ngừa các defects

Các loại lỗi điển hình được tìm thấy bởi Static Analysis:

Tham chiếu tới một biến với một giá trị không xác định

Giao tiếp không đồng nhất giữa các module và các thành phần

Tìm ra các biến không được sử dụng hoặc kê khai không đúng

Đoạn code không chạy đến ( hay đã chết)

Thiếu và logic sai lầm ( vòng có khả năng vô hạn)

Cấu trúc quá phức tạp

Vi phạm tiêu chuẩn lập trình

Lỗ hổng bảo mật

Vi phạm cú pháp của mã và mô hình phần mềm

Static Analysis by tool thường được sử dụng bởi developer trước hoặc trong khi test component và test integration hoặc khi kiểm tra trong code với tool quản lý cấu hình, và bởi Designer trong mô hình hóa phần mềm.

https://blog.haposoft.com/kiem-thu-phan-mem-2/

Kiểm thử phần mềm: Các kỹ thuật thiết kế kiểm thử (Phần 1).

duongtt

21 September 2018

software testing

Tiếp tục series tóm tắt từ cuốn sách: FOUNDATIONS OF SOFTWARE TESTING ISTQB CERTIFICATION của tác giả Dorothy Graham, Erik van Veenendaal, Isabel Evans và Rex Black và một số kinh nghiệm của cá nhân trong quá trình làm việc nhằm cung cấp cho các bạn một cái nhìn tổng quan về kiểm thử phần mềm và các kiến thức cơ bản về kiểm thử, các kỹ thuật dùng trong kiểm thử và các công cụ hỗ trợ.

Tiếp nối bài viết trước Kiểm thử phần mềm: Các kỹ thuật tĩnh (Static techniques) trong bài viết lần này mình sẽ giới thiệu với các bạn các kỹ thuật thiết kế kiểm thử bài đầu tiên là cách Xác định điều kiện test và thiết kế các test case.

1. Giới thiệu.

Trước khi bắt đầu kiểm thử chúng ta cần xác định mình đang cố gắng kiểm tra cái gì, đầu vào, các kết quả cần đạt được. Trong phần này chúng ta sẽ xem xét ba điều kiện sau: điều kiện kiểm thử, testcase và các thủ tục kiểm thử (hoặc các kịch bản). Các điều kiện kiểm thử được ghi lại trong tài liệu chi tiết kỹ thuật thiết kế kiểm thử và chúng ta sẽ xem xét chọn điều kiện kiểm thử và ưu tiên chúng như thế nào. Cách viết testcase như thế nào cho tốt, nguồn gốc để có cơ sở của kiểm thử. Các thủ tục được ghi lại trong quy trình kiểm thử như thế nào, xem xét việc tạo ra một kế hoạch thực thi kiểm thử và sử dụng các ràng buộc về sự ưu tiên, kỹ thuật và logic như thế nào?.

Trong phần này chúng ta sẽ đi tìm hiểu các định nghĩa của các thuật ngữ sau: test case, testcase specification, test condition, test data, test procedure specification, test script and traceability.

2. Hình thức của tài liệu test.

Kiểm thử chính thức(formal testing) giúp kiểm soát tốt hơn các tài liệu có phạm vi rộng. Tài liệu chi tiết ghi lại, bao gồm: các đầu vào cụ thể và chính xác, kết quả kỳ vọng.

Kiểm thử không chính thức có thể không có tài liệu hướng dẫn hoặc chỉ được ghi chú lại bởi cá nhân người kiểm thử.Mức độ hình thức của tài liệu cũng chịu ảnh hưởng từ công ty như: văn hóa, nhân viên, các quy trình phát triển hoàn thiện như thế nào?, quy trình kiểm thử hoàn thiện như thế nào?. Tính toàn vẹn của tài liệu kiểm thử cũng phụ thuộc vào ràng buộc thời gian, áp lực thời gian qua hạn, một tài liệu tốt có thể bị xâm phạm.

3. Xác định điều kiện kiểm thử (test conditions).

Một điều kiện kiểm thử là một vấn đề đơn giản nào đó mà chúng ta có thể kiểm tra được hay nói cách khác: một điều kiện kiểm thử được xác định là một mục hoặc một sự kiện của một thành phần hoặc hệ thống có thể được xác nhận bởi một hoặc nhiều trường hợp kiểm tra. Nếu muốn đo độ bao phủ của các quyết định code thì cơ sở kiểm thử sẽ chính là code và danh sách điều kiện kiểm thử sẽ là kết quả của các quyết định ( đúng hoặc sai).

Khi xác định điều kiện kiểm thử chúng ta mong muốn mở rộng để xác định được nhiều nhất có thể các điều kiện kiểm thử, rồi sau đó chọn lọc cái nào cần phát triển chi tiết hơn và đưa vào test case (gọi là khả năng kiểm thử-test possibilities). Các điều kiện kiểm thử có thể xác định cho dữ liệu kiểm thử cũng như kiểm tra các đầu vào, kết quả đầu ra.

ví dụ: các loại bản ghi khác nhau, sự phân bố khác nhau của các loại tài liệu trong một file hoặc cơ sở dữ liệu, kích thước khác nhau của tài liệu hoặc các trường trong một bản ghi.

4. Xác định test case.

Một test case bao gồm một tập hợp các giá trị đầu vào, điều kiện tiên quyết thực hiện, kết quả mong đợi và hậu thực hiện, phát triển cho một điều kiện khách quan hoặc kiểm tra cụ thể. Khi xác định một test case cần đầu vào cụ thể, chính xác và chi tiết để những người không biết gì về hệ thống cũng có thể test được.Khi một giá trị đầu vào của hệ thống đã cho được chọn, tester cần xác định kết quả mong đợi ban đầu là gì và ghi lại nó như một phần của test case. Kết quả mong đợi bao gồm thông tin được hiển thị trên màn hình để phản hồi đầu vào, các thay đổi đối với dữ liệu hoặc trạng thái và bất kỳ ảnh hưởng nào khác của kiểm thử.Các test case có độ ưu tiên cao hơn sẽ được thực hiện trước, test case có độ ưu tiên thấp sẽ được thực hiện sau hoặc có thể không được thực hiện.

5. Xác định các thủ tục/kịch bản kiểm thử(Test procedures or scripts).

Bước tiếp theo là nhóm các testcase một cách hợp lý để thực hiện chúng và xác định các bước tuần tự cần phải được thực hiện để chạy thử.

Thủ tục kiểm thử: Tài liệu quy định một chuỗi các hành động để thực hiện một kiểm tra. Còn được gọi là kịch bản kiểm thử. Nó phụ thuộc vào kĩ năng và kiến thức của tester, đồng thời cũng phụ thuộc vào yêu cầu từ tài liệu. Kế hoạch kiểm thử sẽ cho biết khi nào thì một kịch bản được thực hiện và được thực hiện bởi ai, kế hoạch có thể thay đổi tùy thuộc vào những rủi ro mới có ảnh hưởng đến mức độ ưu tiên của một kịch bản nhằm giải quyết những rủi ro đó. Các sự phụ thuộc về logic và kỹ thuật giữa các kịch bản cũng sẽ được tính đến khi lên kế hoạch cho các kịch bản. Ví dụ một kịch bản hồi quy có thể luôn được chạy đầu tiên khi có phiên bản mới của phần mềm đến, như smoke test hoặc sanity check.Chúng ta sẽ tìm hiểu một chút về smoke test và sanity check nhé.

Smoke test là một loại kiểm thử phần mềm giúp đảm bảo rằng các chức năng chính của ứng dụng hoạt động tốt. Loại thử nghiệm này còn được gọi là "Build Verification testing". Nó là một kiểu thử nghiệm không đầy đủ với các trường hợp kiểm tra rất hạn chế nhằm đảm bảo những tính năng quan trọng hoạt động đúng và sẵn sàng để test chi tiết.

sanity check là một kỹ thuật kiểm thử phần mềm được thực hiện sau khi nhận được software build, với sự thay đổi nhỏ trong mã, hay chức năng, để xác định rằng các lỗi đã được fix và không còn vấn đề do thay đổi này nữa.

Sự khác nhau giữa smoke test và sanity check: Viết các thủ tục kiểm thử để ưu tiên các kiểm thử quan trọng được thực hiện trong giới hạn thời gian có sẵn. Có một nguyên tắc mà chúng ta cần áp dụng đó là "Find the scary stuff first" có nghĩa là tìm những thứ đáng sợ trước, còn "đáng sợ" như thế nào thì phải tùy vào nghiệp vụ, hệ thống hay dự án.Bài viết sau mình sẽ giới thiệu các loại kỹ thuật thiết kế kiểm thử.Link bài viết tiếp theo Kiểm thử phần mềm: Các kỹ thuật thiết kế kiểm thử (Phần 2).

https://blog.haposoft.com/kiem-thu-phan-mem-cac-ky-thuat-thiet-ke-kiem-thu-phan-2/

# Kiểm thử phần mềm: Các kỹ thuật thiết kế kiểm thử (Phần 2).

###### duongtt

24 September 2018

software testing

Tiếp tục series tóm tắt từ cuốn sách: FOUNDATIONS OF SOFTWARE TESTING ISTQB CERTIFICATION của tác giả Dorothy Graham, Erik van Veenendaal, Isabel Evans và Rex Black và một số kinh nghiệm của cá nhân trong quá trình làm việc nhằm cung cấp cho các bạn một cái nhìn tổng quan về kiểm thử phần mềm và các kiến thức cơ bản về kiểm thử, các kỹ thuật dùng trong kiểm thử và các công cụ hỗ trợ.

Tiếp nối bài viết trước Kiểm thử phần mềm: Các kỹ thuật thiết kế kiểm thử (Phần 1). bài viết lần này mình sẽ giới thiệu với các bạn Các loại kỹ thuật thiết kế kiểm thử - Kiểm thử hộp đen (Black box).

## 1. Giới thiệu.

Có nhiều loại kỹ thuật kiểm thử phần mềm mỗi loại đều có điểm mạnh điểm yếu riêng. Mỗi kỹ thuật đều có điểm mạnh khi tìm ra các loại lỗi cụ thể và tương đối kém khi tìm ra một loại khác. Kiểm thử được thực hiện ở các giai đoạn khác nhau của vòng đời phát triển phần mềm sẽ tìm ra các loại lỗi khác nhau, kiểm thử thành phần có nhiều khả năng tìm thấy các lỗi logic trong việc mã hóa hơn so với các lỗi bên thiết kế hệ thống.

Có 2 loại kỹ thuật chính là kiểm thử tĩnh và kiểm thử động, các kỹ thuật tĩnh đã giới thiệu ở chương 3 rồi còn các kỹ thuật động được chia thành 3 loại khác nhau: dựa trên chi tiết kỹ thuật-specification-based (Hộp đen còn được gọi là kỹ thuật hành vi), dựa trên cấu trúc- structure-based (Hộp trắng hoặc kỹ thuật thuộc về kiến trúc) và dựa trên kinh nghiệm- experience-based.

## 2. Kỹ thuật dựa trên các đặc tả kỹ thuật (kỹ thuật hộp đen-Blackbox).

Kiểm tra hộp đen (Black box testing) là một phương pháp kiểm thử phần mềm mà việc kiểm tra các chức năng của một ứng dụng không cần quan tâm vào cấu trúc nội bộ hoặc hoạt động của nó. Mục đích chính của kiểm tra hộp đen chỉ là để xem phần mềm có hoạt động như dự kiến trong tài liệu yêu cầu và liệu nó có đáp ứng được sự mong đợi của người dùng hay không.

Đặc điểm

Đây là kiểu kiểm thử thành phần phần mềm và chỉ dựa vào các thông tin đặc tả về yêu cầu, chức năng của các thành phần phần mềm tương ứng.

Việc kiểm thử được thực hiện bên ngoài, không liên quan đến lập trình viên hay các nhà phát triển phần mềm. Vì thế người kiểm thử cũng không cần thiết phải biết về cấu trúc bên trong của phần mềm cũng như các kiến thức về lập trình.

Mức test này thường yêu cầu các tester phải viết test case đầy đủ trước khi test; Các bước tiến hành test khá đơn giản, chỉ cần thực hiện theo các mô tả trong test case, thực hiện nhập dữ liệu vào, đợi kết quả trả về và so sánh với kết quả dự kiến trong test case.

Trong phần này, chúng ta sẽ làm quen với các thuật ngữ: phân tích giá trị biên(boundary value analysis) , kiểm thử bảng quyết định (decision table testing), phân vùng tương đương(equivalence partitioning), kiểm tra chuyển tiếp trạng thái(state transition testing) và kiểm tra ca sử dụnguse case testing.Có 4 kỹ thuật dựa trên các đặc tả kỹ thuật:

Phân vùng tương đương (equivalence partitioning)

Phân tích giá trị biên(boundary value analysis)

Bảng quyết định (decision tables)

Kiểm thử chuyển đổi trạng thái (state transition testing).

### 2.1. Phân vùng tương đương(equivalence partitioning).

Phân vùng tương đương: là phương pháp kiểm thử hộp đen chia miền đầu vào của một chương trình thành các lớp dữ liệu, từ đó suy dẫn ra các ca kiểm thử. Tất cả các giá trị trong một vùng tương đương sẽ cho một kết quả đầu ra giống nhau. Vì vậy chúng ta có thể test một giá trị đại diện trong vùng tương đương.Thiết kế test case bằng phân vùng tương đương tiến hành theo hai bước: xác định các lớp tương đương, xác định các trường hợp kiểm thử.

Xác định lớp tương đương:

Lớp tương đương được xác định bằng cách lấy mỗi trạng thái đầu vào và chia nó thành 2 hay nhiều nhóm.

Điều kiện đầu vào: vùng tương đương hợp lệ và vùng tương đương không hợp lệ. Vùng tương đương hợp lệ: là mô tả các đầu vào hợp lệ của chương trình, vùng tương đương không hợp lệ: là mô tả các trạng thái của chương trình như sai, thiếu…

Nguyên tắc xác định vùng tương đương:

Nếu điều kiện đầu vào định rõ giới hạn của một mảng thì chia vùng tương đương thành 3 tình huống: xác định một vùng tương đương hợp lệ, 2 vùng tương đương không hợp lệ.

Nếu điều kiện đầu vào chỉ định là một tập giá trị thì chia vùng tương đương thành 2 tình huống: một vùng hợp lệ và một vùng không hợp lệ.

Nếu điều kiện đầu vào xác định là một kiểu đúng sai thì chia vùng tương đương thành 2 tình huống: một vùng hợp lệ và một vùng không hợp lệ.

Ví dụ: Thiết kế test case nhập vào ô textbox số tiền chỉ cho nhập ký tự là số với độ dài trong khoảng [0-10]

Dựa vào yêu cầu bài toán ta có thể có các lớp tương đương(phân vùng) sau:Phân vùng 1: Nhập giá trị hợp lệ từ 0=> 10 ký tựPhân vùng 2: Nhập giá trị không hợp lệ < 0 ký tựPhân vùng 3: Nhập giá trị không hợp lệ > 10 ký tựPhân vùng 4: Trường hợp để trống không nhập gì hay nhập ký tự không phải dạng số

Sau khi áp dụng phân vùng tương đương có thể chọn được các ca kiểm thử (test case) sau:Case 1: Nhập giá trị từ 0 => 10 (có thể chỉ nhập số 5)=> passCase 2: Nhập giá trị < 0 (có thể chỉ nhập số -5) => hiển thị lỗiCase 3: Nhập giá trị > 10 => hiển thị lỗiCase 4: Để trống không nhập gì hay nhập ký tự không phải dạng số => hiển thị lỗi

Ưu điểm:

Do mỗi vùng tương đương chỉ cần test trên các phần tử đại diện nên số lượng testcase được giảm đi khá nhiều nhờ đó mà thời gian thực hiện test cũng giảm đáng kể.

Toàn bộ yêu cầu của hệ thống được kiểm thử chính xác.

Các tester có thể không cần phải là biết về IT

Nhược điểm:

Có thể bị sót lỗi ở những giá trị biên.

Dữ liệu đầu vào yêu cầu một khối lượng mẫu (sample) khá lớn.

Khó viết kịch bản kiểm thử do cần xác định tất cả các yếu tố đầu vào, và thiếu cả thời gian cho việc tập hợp này.

### 2.2. Phân tích giá trị biên(Boundary value analysis (BVA)).

Đây là phương pháp test mà chúng ta sẽ test tất cả các giá trị ở vùng biên của dữ liệu vào và dữ liệu ra. Nếu dữ liệu đầu vào được sử dụng là trong giới hạn giá trị biên, nó được cho là Positive testing. Nếu dữ liệu đầu vào được sử dụng là ngoài giới hạn giá trị biên, nó được cho là Negative testing.

Phân tích giá trị biên sẽ chọn các giá trị:

Giá trị nhỏ nhất

Giá trị ngay trên giá trị nhỏ nhất

Giá trị bình thường

Giá trị ngay dưới giá trị lớn nhất

Giá trị lớn nhất

Ưu điểm: Thay vì phải test hết toàn bộ các giá trị trong từng vùng tương đương, kỹ thuật phân tích giá trị biên tập trung vào việc kiểm thử các giá trị biên của miền giá trị đầu vào để thiết kế test case do “lỗi thường tiềm ẩn tại các ngõ ngách và tập hợp tại biên”. Tiết kiệm thời gian thiết kế test case và thực hiện test.

Nhược điểm: Phương pháp này chỉ hiệu quả trong trường hợp số đầu vào (input variables) độc lập với nhau và mỗi đối số đều có một miền giá trị hữu hạn.

## 2.3. Bảng quyết định (Decision tables )

Bảng quyết định sử dụng mô hình các quan hệ logic giữa nguyên nhân và kết quả cho các thành phần. Mỗi nguyên nhân được biểu diễn như một điều kiện (đúng hoặc sai) của một đầu vào, hoặc kết hợp các đầu vào. Mỗi kết quả được biểu diễn như là một biểu thức Bool biểu diễn một kết quả tương ứng cho những thành phần vừa thực hiện.Sử dụng bảng quyết định trong thiết kế kiểm thử bao gồm các bước sau:

Xác định một chức năng phù hợp hoặc hệ thống con mà có sự kết hợp của các yếu tố đầu vào

Chúng ta đi xem xét ví dụ: ứng dụng vay tiền, có thể nhập số tiền trả nợ hàng tháng hoặc số năm muốn vay (thời hạn của khoản vay). Nếu nhập vào cả hai, hệ thống sẽ tạo sự thỏa hiệp giữa hai vấn đề nếu chúng xung đột. Hai điều kiện là số tiền trả hàng tháng và thời hạn vay, vì vậy ta đặt chúng trong một bảng.

Bảng 4.1. Xác định các điều kiện.

Xác định tất cả các kết hợp các điều kiện. Phải tính toán bao nhiêu cột trong bảng số lượng các cột phụ thuộc vào các điều kiện và số lượng các lựa chọn thay thế cho mối điều kiện. Nếu có 2 điều kiện và từng điều kiện có thể là đúng hoặc sai cần 4 cột = 2^2

Bảng 4.2. Kết hợp các điều kiện

Xác định kết quả chính xác cho mỗi sự kết hợp. Trong ví dụ này chúng ta có thể nhập vào một hoặc cả hai trường, mỗi sự kết hợp là một quy luật

Bảng 4.3. Bảng quyết định với sự kết hợp của các điều kiện và kết quả.- Xác định những case bị thiếu sót. Trong ví dụ này chúng ta có thể thấy được trường hợp nếu khách hàng không nhập thông tin ở một trong hai trường thì sẽ xảy ra điều gì.

Bảng 4.4. Bảng quyết định với kết quả bổ sung.

Thực hiện thay đổi điều kiện: không cho phép nhập cả 2 điều kiện trên cùng lúc. Kết quả của bảng sẽ thay đổi, thông báo lỗi nếu cả 2 điều kiện được nhập vào.

Bảng 4.5. Bảng quyết định với sự thay đổi kết quả.

Mỗi hành động xảy ra cho mỗi sự kết hợp các điều kiện, chúng ta có thể liệt kê các hành động trong ô thành một hàng. Nhưng đối với những kết hợp có nhiều kết quả nên hiển thị thành từng hàng riêng biệt.

Bảng 4.6. Bảng quyết định trên một hàng.

Bước cuối cùng là viết các test case cho các trường hợp kết hợp điều kiện từ kết quả của các bảng điều kiện trên.

### 2.4. Kiểm thử chuyển đổi trạng thái(State transition testing)

Kiểm thử chuyển đổi trạng thái được sử dụng khi một số khía cạnh của hệ thống được mô tả trong máy hữu hạn các trạng thái(finite state machine). Có thể hiểu là các hệ thống có thể nằm trong số (hữu hạn) các trạng thái và sự chuyển tiếp từ trạng thái này sang trạng thái khác được xác định bởi các quy tắc máy. Một hệ thống trạng thái hữu hạn thường được biểu diễn dưới dạng sơ đồ trạng thái (state diagram).

Một mô hình chuyển đổi trạng thái có 4 phần cơ bản sau:

Các trạng thái mà phần mềm có thể giữ (đóng/mở hoặc không đủ số dư, tài khoản hết hạn…).

Sự chuyển từ trạng thái này sang trạng thái khác( không phải tất cả quy trình chuyển đổi đều được cho phép).

Các sự kiện gây ra sự chuyển đổi ( đóng file hoặc rút tiền).

Kết quả của các hành động từ quá trình chuyển đổi ( thông báo lỗi hoặc đưa tiền mặt )

Chú ý rằng trong một trạng thái một sự kiện chỉ có thể gây ra một hành động duy nhất. Tuy nhiên cùng với sự kiện đó mà xảy ra ở trạng thái khác sẽ cho ra các hành động khác và trạng thái kết thúc khác nhau.

Hình 4.1. Cho một ví dụ về nhập mã PIN ở cây ATM. Các trạng thái được thể hiện ở dạng hình tròn. Các phiên chuyển đổi là các mũi tên. Các event là dòng text cạnh mũi tên:

Hình 4.1. Sơ đồ trạng thái của việc nhập mã PIN.

Từ sơ đồ trạng thái, tiến hành tạo test case bắt đầu từ việc xác định các kịch bản (scenario).

Trường hợp 1: khi mà mã PIN được nhập đúng ngay ở lần đầu tiên.

Trường hợp 2: nhập sai mã PIN ở cả lần 1, lần 2 và lần 3.

Các trường hợp tiếp theo sẽ kiểm thử trường hợp với từng trạng thái ví dụ như nhập đúng ở lần đầu tiên, sai ở lần thứ 2 hoặc sai ở 2 lần đầu và đúng ở lần thứ 3. Một trạng thái có thể được nhìn nhận như một điều kiện test hoặc mỗi một phiên chuyển đổi sẽ được nhìn nhận như một điều kiện test.

Tiếp theo, Để xem có bao nhiêu tổng số kết hợp các trạng thái và quá trình chuyển đổi cả 2 trạng thái hợp lệ và không hợp lệ cần phải có một bảng trạng thái.

Hình 4.2. Ví dụ bảng trạng thái của nhập mã PIN.

Bảng 4.2 liệt kê các trạng thái trong cột thứ nhất, các đầu vào có thể ở hàng đầu. Nếu hệ thống đang ở trạng thái 1, inserting a card sẽ chuyển đổi sang trạng thái 2. Nếu đang ở trạng thái 2 và đã nhập Valid PIN sẽ chuyển sang trạng thái 6, Nếu đang ở trạng thái 2 và đã nhập Invalid PIN sẽ chuyển sang trạng thái 3.

### 2.5. Kiểm thử các trường hợp sử dụng(Use case testing).

Use case testing là một kỹ thuật xác định các test case mô tả từ đầu đến cuối hành vi của hệ thống từ góc nhìn của người sử dụng. Use case mô tả sự tương tác đặc trưng giữa người dùng bên ngoài (Actor) và hệ thống. Mỗi Use case sẽ mô tả cách thức người dùng tương tác với hệ thống để đạt được mục tiêu nào đó. Ngoài ra, Use case cũng xác định trình tự các bước mô tả mọi tương tác giữa người dùng và hệ thống.Mô tả hoạt động của usecase thì người ta thường dùng Workflow hoặc mô hình activity, UML.Các thành phần của use case:

Tác nhân (Actor): Người dùng hoặc đối tượng nào đó tương tác với hệ thống.

Brief description: Mô tả ngắn gọn giải thích các trường hợp

Precondition: Là các điều kiện được thỏa mãn trước khi bắt đầu thực hiện

Basic flow: là những luồng cơ bản trong hệ thống. Đó là luồng giao dịch được thực hiện bởi người dùng để hoàn thành mục đích của họ. Khi người dùng tương tác với hệ thống, vì đó là workflow bình thường nên sẽ không có bất kì lỗi nào xảy ra và người dùng sẽ nhận được đầu ra như mong đợi.

Alternate flow: Ngoài workflow thông thường, hệ thống cũng có thể có workflow thay thế. Đây là tương tác ít phổ biến hơn được thực hiện bởi người dùng với hệ thống

Exception flow: Là các luồng ngăn cản người dùng đạt được mục đích của họ

Post conditions: Các điều kiện cần được kiểm tra sau khi hoàn thành.

Trong ví dụ nêu trên mỗi use case là một kịch bản scenario và phần mở rộng (thể hiện các kịch bản có thể không thành công). Đối với kiểm thử use case, có một kịch bản của kiểm thử thành công và một kiểm thử cho mỗi phần mở rộng

Hình 4.3. Một phần use case cho phần nhập mã PIN.

Trên đây là một số kỹ thuật thường được sử dụng trong kiểm thử dựa trên các đặc tả kỹ thuật (Black box). Bài viết tiếp theo mình sẽ giới thiệu Các kỹ thuật dựa trên cấu trúc/kiến trúc của hệ thống (White box), các kỹ thuật dựa trên kinh nghiệm và .

https://blog.haposoft.com/kiem-thu-phan-mem-cac-ky-thuat-thiet-ke-kiem-thu-phan-3/

# Kiểm thử phần mềm: Các kỹ thuật thiết kế kiểm thử (Phần 3).

###### duongtt

28 September 2018

software testing

Tiếp tục series tóm tắt từ cuốn sách: FOUNDATIONS OF SOFTWARE TESTING ISTQB CERTIFICATION của tác giả Dorothy Graham, Erik van Veenendaal, Isabel Evans và Rex Black và một số kinh nghiệm của cá nhân trong quá trình làm việc nhằm cung cấp cho các bạn một cái nhìn tổng quan về kiểm thử phần mềm và các kiến thức cơ bản về kiểm thử, các kỹ thuật dùng trong kiểm thử và các công cụ hỗ trợ.

Tiếp nối bài viết trước Kiểm thử phần mềm: Các kỹ thuật thiết kế kiểm thử (Phần 2). bài viết lần này mình sẽ giới thiệu với các bạn Các loại kỹ thuật thiết kế kiểm thử - Kiểm thử hộp trắng(White box) và kiểm thử dựa trên kinh nghiệm.

## 1. Các kỹ thuật dựa trên cấu trúc/kiến trúc của hệ thống (Kiểm thử hộp trắng-Blackbox).

Kiểm thử hộp trắng là loại thử nghiệm được thực hiện để kiểm tra cấu trúc code. Loại thử nghiệm này đòi hỏi người test phải có kiến thức về code. Do đó, phần lớn là do các lập trình viên, nhà phát triển phần mềm thực hiện.

Đặc điểm

Kiểm thử hộp trắng quan tâm đến việc hệ thống vận hành như thế nào chứ không phải chứ năng của hệ thống. Vì nó dựa vào những thuật toán cụ thể, vào những cấu trúc dữ liệu bên trong của thành phần phần mềm.

Trong kỹ thuật kiểm thử này, đòi hỏi người tester phải có kiến thức và kỹ năng nhất định về ngôn ngữ lập trình được dùng, hiểu thuật toán trong phần mềm, để có thể hiểu được chi tiết về đoạn code cần kiểm thử .

Mức test này thường yêu cầu các tester phải viết test case đầy đủ các nhánh trong code; khi test, sẽ set điều kiện và data để chạy vào đủ tất cả các nhánh trong thuật toán, đảm bảo thực hiện đầy đủ.

Kiểm thử hộp trắng được dùng để đo độ bao phủ( coverage ) và kiểm thử thiết kế(Design test).Bao phủ kiểm thử(test coverage ) là tỉ lệ (tính theo %) test case đã được thực hiện trên tổng số test case cần thiết cho phần mềm. Nếu tỉ lệ này càng cao thì phần mềm càng được test kỹ. Mặc dù việc đảm bảo phần mềm có test coverage là 100% nhưng không có nghĩa là 100% các trường hợp được kiểm thử. Độ bao phủ được tính bằng công thức sau:

Có nghĩa là độ bao phủ = Số item bao phủ được thực hiện/ Tổng số item bao phủ * 100%

Có 2 loại điều kiện bao phủ cơ bản: Bao phủ code(Code coverage), Bao phủ chức năng(function coverage).

Code coverage Là phương pháp thống kê dựa vào số lương code được kiểm tra. Trong code coverage có thể phần chia thành các loại sau:

Bao phủ dòng lệnh(Statement coverage)

Bao phủ các nhánh (Branch/Decision coverage)

Bao phủ điều kiện (Condition coverage)

Bao phủ đường dẫn (Path coverage)

Kiểm thử hộp trắng có 2 hoạt động chính: kiểm thử luồng điều khiển(control flow testing) và kiểm thử luồng dữ liệu(data flow testing).

Kiểm thử luồng điều khiển: là một chiến lược trong kiểm thử cấu trúc nó sử dụng luồng điều khiển của chương trình như một mô hình. Nó dựa vào việc lựa chọn một tập các đường dẫn kiểm tra thông qua chương trình. Tập các đường dẫn đã chọn được sử dụng để đạt được một số đo nhất định của việc kiểm thử cẩn thận.

Kiểm thử luồng dữ liệu: là một nhóm các chiến lược kiểm tử dựa trên việc chọn các đường dẫn thông qua luồng điều khiển của chương trình để khám phá chuỗi các sự kiện liên quan đến trạng thái của các biến hoặc các đối tượng dữ liệu. Kiểm tra Dataflow tập trung vào các điểm mà tại đó các biến nhận giá trị và các điểm mà tại đó các giá trị này được sử dụng.

Ưu điểm

Test có thể bắt đầu ở giai đoạn sớm hơn, không cần phải chờ đợi cho GUI để có thể test

Test kỹ càng hơn, có thể bao phủ hầu hết các đường dẫn

Thích hợp trong việc tìm kiếm lỗi và các vấn đề trong mã lệnh

Cho phép tìm kiếm các lỗi ẩn bên trong

Các lập trình viên có thể tự kiểm tra

Giúp tối ưu việc mã hoá

Do yêu cầu kiến thức cấu trúc bên trong của phần mềm, nên việc kiểm soát lỗi tối đa nhất.

Nhược điểm

Vì các bài kiểm tra rất phức tạp, đòi hỏi phải có các nguồn lực có tay nghề cao, với kiến thức sâu rộng về lập trình và thực hiện.

Maintenance test script có thể là một gánh nặng nếu thể hiện thay đổi quá thường xuyên.

Vì phương pháp thử nghiệm này liên quan chặt chẽ với ứng dụng đang được test, nên các công cụ để phục vụ cho mọi loại triển khai / nền tảng có thể không sẵn có.

## 2. Kỹ thuật dựa trên kinh nghiệm (EXPERIENCE-BASED TECHNIQUES)

Có 4 kỹ thuật dựa trên kinh nghiệm: Đoán lỗi(Error guessing), Kiểm thử thăm dò(Exploratory testing), kiểm thử dựa trên checklist(Checklist based testing), (Attack testing). Nhưng ở bài viết này mình chỉ giới thiệu 2 kỹ thuật: Đoán lỗi(Error guessing), Kiểm thử thăm dò(Exploratory testing)

### 2.1. Đoán lỗi(Error guessing).

Đoán lỗi(error guessing) là một phương pháp kiểm thử, trong đó các trường hợp kiểm thử được sử dụng để tìm lỗi trong các phần mềm dựa vào kinh nghiệm trong các lần kiểm thử trước của người kiểm thử (tester). Việc đoán lỗi thành công phụ thuộc rất nhiều vào kỹ năng của người kiểm thử, một người kiểm thử giỏi có thể biết được nơi nào có nhiều lỗi tiềm ẩn.

Đoán Lỗi không có quy tắc rõ ràng để kiểm thử, test case có thể được thiết kế tùy thuộc vào tình hình, hoặc hoặc luồng công việc trong các tài liệu mô tả chức năng hoặc khi một lỗi không mong muốn / không được mô tả trong tài liệu được tìm thấy trong khi hoạt động kiểm thử. các điều kiện điển hình để kiểm thử bao gồm chia cho số 0, để trống đầu vào, file rỗng và kiểu dữ liệu sai.

Các yếu tố được sử dụng để đoán lỗi:

Kinh nghiệm từ những lần kiểm thử trước.

Những khuyết thiếu (defect) trước.

Xem lại những trường hợp đã kiểm thử.

Giao diện người dùng.

Kết quả của những lần test trước.

Dựa vào những báo cáo về rủi ro của hệ thống hoặc của phần mềm.

Dựa vào các loại dữ liệu được sử dụng để test.

Mặc dù, đoán lỗi là một trong những kỹ thuật chính trong kiểm thử nhưng không bao quát đầy đủ được hệ thống, cũng không thể đảm bảo hệ thống đạt được chất lượng như mong đợi. Do vậy nên kết hợp với các kỹ thuật khác để mang lại hiệu quả tốt hơn.

### 2.2. Kiểm thử thăm dò(Exploratory testing).

Đối với kiểm thử thông thường, theo kịch bản có sẵn, bạn sẽ thiết kế test case trước, sau đó tiến hành thực hiện kiểm thử. Ngược lại, kiểm thử thăm dò là việc thực hiện đồng thời thiết kế và thực hiện kiểm thử.

Kiểm thử thăm dò bao gồm tất cả các việc như: phát hiện lỗi, điều tra lỗi, sự hiểu biết về ứng dụng. Điều này chú trọng vào sự tự do cá nhân và trách nhiệm của từng nhân viên. Test cases có thể không được tạo hoàn chỉnh nhưng người thực hiện vẫn có thể kiểm tra hệ thống một cách nhanh chóng. Họ có thể ghi lại ngắn gọn những gì mình cần làm trước khi thực hiện kiểm thử. Kiểm thử thăm dò tập trung nhiều hơn vào việc thực hiện kiểm thử hơn là tạo test cases.

Kiểm thử thăm dò :

Không phải là kiểm thử ngẫu nhiên nhưng nó là kiểm thử mang tính bột phát với mục đích tìm được các lỗi.

Có cấu trúc và chặt chẽ.

Dễ dàng quản lý.

Không phải là một kĩ thuật nhưng là một phương pháp tiếp cận. Những hành động bạn thực hiện tiếp theo được điều chỉnh bởi những gì bạn đang làm.

Một khía cạnh quan trọng của kiểm thử thăm dò là học hỏi: học hỏi người kiểm thử về phần mềm, cách sử dụng, điểm mạnh và điểm yếu của hệ thống. kiểm thử thăm dò là dò xét, tìm hiểu về phần mềm, hệ thống làm những gì và không làm những gì, những bộ phận nào làm việc và bộ phận nào không làm việc. Người kiểm thử liên tục liên tục đưa ra quyết định về những vấn đề kiểm tra tiếp theo và nơi để chi tiêu thời gian.

Ưu điểm:

Phương pháp này không yêu cầu chuẩn bị cho quá trình test như là việc chúng ta không có tài liệu cho hoạt động kiểm thử.

Thời gian trong quá trình test được tiết kiệm do tất cả các nhiệm vụ test được làm cùng một lúc như là quá trình test, thiết kế kịch bản kiểm thử và thực hiện các kịch bản kiểm thử.

Nhân viên kiểm thử (QA) có thể báo cáo nhiều vấn đề do yêu cầu không đầy đủ hoặc tài liệu yêu cầu còn thiếu.

Nhược điểm:

Vài vấn đề không thể được khai thác trong kiểu test này.

Có xem xét lại các kế hoạch kiểm tra và thiết kế testcase/kịch bản test trong khi quá trình test có xảy ra vấn đề.

Những nhân viên kiểm thử (QA) cần phải nhớ kịch bản test - những gì đang thực hiện test bởi vì nếu có lỗi được tìm thấy, tester (QA) sẽ “report a bug” với các bước thích hợp để tái hiện lại nó, với các lỗi khó tái hiện cần phải mô tả các bước một cách thích hợp để thực hiện một cách chính xác lỗi mà anh ta đã báo cáo đặc biệt là với các lỗi mới được tìm thấy.

# 3. Chọn kỹ thuật kiểm thử.

Trong phần cuối cùng này, chúng ta đi xem xét các yếu tố đưa ra các quyết định về từng kỹ thuật và khi nào thì sử dụng.

Các yếu tố nội bộ ảnh hưởng đến các quyết định sử dụng kỹ thuật nào là thích hợp:

Các mô hình được sử dụng: khi sử dụng các kỹ thuật kiểm thử dựa trên mô hình, các mô hình có sẵn( tức là được phát triển, sử dụng trong quá trình thực thi, thiết kế và đặc tả kỹ thuật trong hệ thống) sẽ ảnh hưởng đến phạm vi những kỹ thuật kiểm thử nào có thể được sử dụng.

Các kinh nghiệm, kiến thức của người kiểm thử: có bao nhiêu người kiểm thử biết về hệ thống và về các kỹ thuật kiểm thử sẽ ảnh hưởng rõ ràng đến việc chọn lựa kỹ thuật kiểm thử của mỗi người.

Các lỗi có khả năng xảy ra: dựa vào kinh nghiệm của người kiểm thử để chọn kỹ thuật sử dung.

Các mục tiêu kiểm thử

Tài liệu

Mô hình vòng đời của hệ thống: mô hình vòng đời nối tiếp thích hợp hơn với các kỹ thuật chính thức, còn mô hình vòng đời lặp thích hợp hơn với phương pháp kiểm thử thăm dò.

Các yếu tố bên ngoài ảnh hưởng đến các quyết định sử dụng kỹ thuật nào là thích hợp:

Rủi ro: rủi ro càng lớn ( ví dụ như các hệ thống quan trọng vấn đề an toàn, bảo mật) thì nhu cầu kiểm thử kỹ hơn, chính thức hơn.

Các yêu cầu về hợp đồng của khách hàng: đôi khi trong các hợp đồng có chỉ định các kỹ thuật kiểm thử cụ thể để sử dụng.

Loại hệ thống: loại hệ thống ( như: đồ họa, tài chính, ..) sẽ ảnh hưởng đến việc lựa chọn kỹ thuật, ví dụ: một ứng dụng tài chính sẽ liên quan đến nhiều tính toán sẽ được hưởng lợi việc phân tích giá trị biên.

Các yêu cầu điều chỉnh: một số ngành có các hướng dẫn hoặc tiêu chuẩn cho sự điều chỉnh mà ảnh hưởng đến các kỹ thuật kiểm thử được sử dụng.

Thời gian và ngân sách: khi có nhiều thời gian chúng ta có thể lựa chọn nhiều kỹ thuật kiểm thử hơn nhưng khi thời gian bị giới hạn thì các kỹ thuật cũng được chọn kỹ lưỡng, lựa chọn những kỹ thuật nào có khả năng tìm ra những lỗi quan trọng nhất.

Kết thúc chương 4 tại đây ở bài viết sau mình sẽ giới thiệu chương tiếp theo chương 5: Quản lý kiểm thử.

https://blog.haposoft.com/tim-hieu-chung-apache-jmete/

Apache Jmeter - Apache Jmeter là gì? Cài đặt Apache Jmeter thế nào?

Nguyễn Xuân Lâm

02 October 2018

software testing

Sản phẩm dịch vụ của bạn sẽ ra sao nếu có một lượng lớn người truy cập? Server sẽ phản hồi lại các yêu cầu của Client trong bao lâu?... Apache Jmeter là một ứng dụng phần mềm sẽ giúp các bạn trả lời những câu hỏi đó. Ở trong phần này chúng ta sẽ tìm hiểu tổng quan về Apache Jmeter và cách cài đặt nó.

1. Apache Jmeter là gì

Apache jmeter là một mã nguồn mở được viết hoàn toàn bằng java

Là công cụ để kiểm tra hiệu suất (Performance) trên cả tài nguyên tĩnh (Static) và tài nguyên động (Dynamic)

Và được dùng để đo độ tải nặng (heave load) trên một server, nhóm server, mạng hoặc các đối tượng khác

2. Tính năng và cách thức hoạt động của Apache Jmeter

Tính năng của Apache Jmeter

Khả năng kiểm thử tải và performance nhiều ứng dụng/ máy chủ/ loại giao thức khác nhau

Web – HTTP, HTTPS (Java, NodeJS, PHP, ASP.NET, …)

SOAP / REST Webservices

FTP

Database via JDBC

LDAP

Message-oriented middleware (MOM) via JMS

Mail – SMTP(S), POP3(S) and IMAP(S)

Native commands or shell scripts

TCP

Các đổi tượng Java

Đầy đủ các tính năng test IDE, cho phép ghi lại các test plan một cách nhanh chóng (Từ trình duyệt hoặc các ứng dụng )

Chế độ dòng lệnh (Command-line) để kiểm tra độ tải từ các hệ điều hành tương thích với Java (Linux, Window, Mac …)

Đưa ra báo cáo và trình bày HTML động

Dễ dàng tương tác thông qua khả năng trích xuất dữ liệu từ các định dạng phản hồi phổ biến như HTML, JSO, XML…

Do viết bằng Java nên nó có tính đa nền tảng (Kiểm thử trên nền tảng nào cũng được)

Cho phép mô phỏng đồng thời nhiều thread

Bộ nhớ đệm và cho phép phân tích, tái hiện kết quả test một cách offiline

Caching and offline analysis/replaying of test results.

Phần lõi có khả năng mở rộng cao

Cách thức hoạt động của Apache Jmeter

Apache Jmeter sẽ giả lập một nhóm người dùng gửi các yêu cầu tới một máy chủ, nhận và xử lý các response từ máy chủ và trình diễn các kết quả đó cho người dùng dưới dạng bảng biểu, đồ thị,cây…

3. Hướng dẫn cài đặt Apache Jmeter

Lưu ý: Vì Apache Jmeter được viết 100% bằng Java nên để chạy được Apache Jmeter các bạn cần phải cài đặt JRE hoặc JDK

Bước 1: Truy cập trang web: http://jmeter.apache.org/download_jmeter.cgi để download Apache JMeter

Bước 2: Giải nén file mới tải

Bước 3: Vào fodler bin > Click vào file ApacheJMeter.jar để chạy Apache JMeter

Chạy Apache Jmeter thành công

Khi làm xong các bước bên trên, bạn sẽ mở được giao diện làm việc của Apache Jmeter như hình

Done~Vậy là chúng ta đã cài đặt xong Apache Jmeter.

Ở phần tiếp theo, chúng ta sẽ tìm hiểu về cách sử dụng Apache Jmeter.

Cảm ơn các bạn đã theo dõi

https://blog.haposoft.com/kiem-thu-phan-mem-cac-cong-cu-ho-tro-cho-viec-kiem-thu-phan-1/

Kiểm thử phần mềm: Các công cụ hỗ trợ cho việc kiểm thử. (Phần 1)

duongtt

08 October 2018

software testing

Tiếp tục series tóm tắt từ cuốn sách: FOUNDATIONS OF SOFTWARE TESTING ISTQB CERTIFICATION của tác giả Dorothy Graham, Erik van Veenendaal, Isabel Evans và Rex Black và một số kinh nghiệm của cá nhân trong quá trình làm việc nhằm cung cấp cho các bạn một cái nhìn tổng quan về kiểm thử phần mềm và các kiến thức cơ bản về kiểm thử, các kỹ thuật dùng trong kiểm thử và các công cụ hỗ trợ.

Tiếp nối bài viết trước Kiểm thử phần mềm: Các công cụ hỗ trợ cho việc kiểm thử. (Phần 2) bài viết lần này mình sẽ giới thiệu với các bạn Các loại công cụ kiểm thử (Types of test tool).Trong phần này mình sẽ giới thiệu một số loại công cụ sau:

Công cụ hỗ trợ quản lý kiểm thử và kiểm tra.

Công cụ hỗ trợ kiểm thử tĩnh.

Các công cụ hộ trợ kiểm tra chi tiết kỹ thuật.

Công cụ hỗ trợ thực thi kiểm thử và logging.

Công cụ hỗ trợ thực hiện và giám sát.

Công cụ hỗ trợ cho từng vùng ứng dụng cụ thể.

Các công cụ khác.

1. Công cụ hỗ trợ quản lý kiểm thử và kiểm tra.

Quản lý kiểm thử(test management). nó có thể là quản lý các bài test hoặc là quản lý quá trình kiểm thử, các công cụ được giới thiệu ở phần này có thể hỗ trợ 1 trong 2 hoặc cả 2. Việc quản lý kiểm thử áp dụng trong toàn bộ vòng đời phát triển phần mềm, do đó, một công cụ quản lý kiểm thử có thể là một trong những công cụ đầu tiên được sử dụng trong một dự án. Trong thực tế, các công cụ quản lý kiểm thử thường được sử dụng bởi các kiểm thử viên hoặc các nhà quản lý kiểm thử ở cấp độ kiểm thử hệ thống hoặc chấp nhận.

1.1. Công cụ quản lý test(Test management tools).

Các tính năng được cung cấp bởi các công cụ quản lý test bao gồm các tính năng được liệt kê dưới đây. Một số công cụ sẽ cung cấp tất cả các tính năng này. Những công cụ khác cung cấp một hoặc nhiều tính năng, tuy nhiên những công cụ này vẫn sẽ được phân loại như các công cụ quản lý test.

Các tính năng hoặc đặc điểm của các công cụ test tập trung hỗ trợ cho:

Quản lý các bài test: ví dụ: theo dõi các dữ liệu liên quan cho một bộ các bài test, biết những kiểm tra nào cần phải chạy trong môi trường chung, số lượng bài test đã được lên kế hoạch, viết, chạy, thông qua hoặc thất bại.

Lập kế hoạch cho các bài test để thực thi( bằng tay hoặc bằng công cụ thực thi).

Quản lý các hoạt động kiểm thử (thời gian chi cho thiết kế test, thực hiện test để xem liệu có hoàn thành đúng kế hoạch và ngân sách).

Giao diện với các công cụ khác, như là:

Công cụ thực thi test (công cụ chạy test).

Công cụ quản lý sự cố.

Công cụ quản lý yêu cầu.

Công cụ quản lý cấu hình.

Truy xuất nguồn gốc của các bài test, kết quả test và các lỗi từ yêu cầu hoặc từ nguồn gốc khác.

Logging kết quả test.

Báo cáo tiến độ dựa trên các chỉ số như: chạy test và test passed, sự cố gia tăng, những lỗi đã sửa và những lỗi lớn.

Những thông tin này có thể được sử dụng để giám sát quy trình kiểm thử và quyết định những hành động nào sẽ kiểm soát được. Công cụ cũng đưa ra thông tin về thành phần hoặc hệ thống đang được test( đối tượng test). Các công cụ quản lý test giúp thu thập, tổ chức và quản lý thông tin kiểm thử của một dự án.

Một số công cụ hỗ trợ quản lý test:

JIRA (incl. Cloud)

FogBugz.

Redmine.

Bugzilla.

1.2. Các công cụ quản lý yêu cầu (Requirements management tools).

Một vài công cụ quản lý yêu cầu có thể tìm thấy các lỗi theo các yêu cầu, ví dụ, kiểm tra những từ không rõ ràng hoặc bị cấm như “might”, “and/or”, “as needed” hoặc “to be decided”.

Các tính năng hoặc đăc điểm của các công cụ quản lý yêu cầu hỗ trợ cho:

Lưu trữ báo cáo yêu cầu.

Lưu trữ các thông tin về các thuộc tính của yêu cầu.

Kiểm tra tính nhất quán của các yêu cầu.

Xác định các yêu cầu không xác định, thiếu hoặc được xác định sau.

Ưu tiên các yêu cầu cho mục đích kiểm thử.

Truy xuất nguồn gốc của yêu cầu đối với các test và các test đối với yêu cầu, chức năng hoặc các tính năng.

Truy xuất nguồn gốc thông qua các mức độ yêu cầu.

Giao diện của các công cụ quản lý test.

Độ bao phủ của các yêu cầu bởi một bộ test.

Một số công cụ hỗ trợ quản lý yêu cầu:

Process Street

Visual Trace Spec

Avolution

Visure

SpiraTeam by Inflectra

1.3. Các công cụ quản lý sự cố (Incident management tools).

Loại công cụ này còn được gọi là công cụ theo dõi thiếu sót, công cụ quản lý thiếu sót hoặc là công cụ quản lý bug. Báo cáo sự cố thông qua một số giai đoạn nhận biết ban đầu và ghi lại chi tiết, thông qua phân tích, phân loại, phân định, công việc sửa lỗi, sửa lỗi, test lại và đóng. Công cụ quản lý sự cố giúp theo dõi các sự cố theo thời gian một cách dễ dàng.

Các tính năng và đặc điểm của các công cụ quản lý sự cố hỗ trợ:

Lưu trữ thông tin về các thuộc tính của sự cố (tính nghiêm trọng).

Lưu trữ các tập tin đính kèm (chụp ảnh màn hình).

Độ ưu tiên của các sự cố.

Phân công hành động cho từng người(sửa chữa, xác nhận test…).

Trạng thái (ví dụ: open, rejected, duplicate, deferred, ready for confirmation test, closed).

Báo cáo thống kê/ số liệu về các sự cố (thời gian mở trung bình, số lượng các sự cố với mỗi trạng thái, tổng số gia tăng, mở hoặc đóng..). Chức năng của công cụ quản lý sự cố có thể bao gồm trong các công cụ quản lý test thương mại.

1.4. Các công cụ quản lý cấu hình (Configuration management tools).

Các công cụ quản lý cấu hình cũng không phải là các công cụ kiểm thử nghiêm ngặt, tuy nhiên việc quản lý cấu hình tốt là rất quan trọng đối với kiểm thử kiểm soát như đã mô tả trong chương 5. Chúng ta cần biết chính xác những vấn đề gì chúng ta hỗ trợ kiểm tra, chẳng hạn như biết chính xác phiên bản của hệ thống. Có thể thực hiện các biện pháp quản lý cấu hình mà không sử dụng công cụ nhưng các công cụ sẽ làm nhanh và dễ dàng hơn, đặc biệt là trong môi trường phức tạp.

Các tính năng và đặc điểm của các công cụ quản lý cấu hình hỗ trợ:

Lưu trữ thông tin về các phiên bản và cấu trúc của phần mềm và testware.

Truy xuất nguồn gốc giữa phần mềm, testware, các phiên bản khác nhau hoặc các biến thể.

Theo dõi các phiên bản nào thuộc về cấu hình nào (ví dụ: hệ điều hành, các thư viện, trình duyệt…).

Quản lý build và release.

Baselining (ví dụ: tất cả loại cấu hình tạo thành một bản release cụ thể).

Kiểm soát việc truy cập (check in hoặc check out).

Một số công cụ quản lý cấu hình:

CHEF

JUJU

Rudder

CFEngine

Ansible

2. Các công cụ hỗ trợ kiểm thử tĩnh.

2.1.Công cụ hỗ trợ quá trình đánh giá (Review process support tools).

Công cụ hỗ trợ đánh giá có thể tự động tính tỷ lệ checking và flag exception. Nó có thể điều chỉnh cho quá trình đánh giá cụ thể hoặc loại hình đánh giá đang thực hiện.

Các tính năng và đặc điểm của các công cụ hỗ trợ quy trình đánh giá:

Đưa ra một tham chiếu chung cho quá trình đánh giá hoặc các quy trình để sử dụng trong các tình huống bất thường.

Lưu trữ và sắp xếp các nhận xét đánh giá.

Truyền tải ý kiến đến những người có liên quan.

Kết hợp các đánh giá trực tuyến.

Theo dõi các nhận xét, bao gồm các lỗi được tìm thấy và cung cấp thông tin thống kê về các lỗi đấy.

Cung cấp khả năng truy xuất nguồn gốc giữa các nhận xét, tài liệu đã đánh giá và các tài liệu liên quan.

Là kho lưu trữ các quy tắc, thủ tục và checklist được sử dụng trong các đánh giá.

Theo dõi tình trạng đánh giá (được thông qua(passed), thông qua với các điều chỉnh(passed with corrections), yêu cầu đánh giá lại(requires rereview)).

Thu thập số liệu và báo cáo các yếu tố chính.

2.2. Các công cụ phân tích tĩnh (static analysis tools)

Các công cụ phân tích tĩnh thường được các nhà phát triển coi như là một phần của quy trình phát triển và kiểm thử thành phần. Các công cụ phân tích tĩnh là phần mở rộng của công nghệ biên dịch, trong thực tế một số trình biên dịch cung cấp các tính năng phân tích tĩnh.

Các công cụ phân tích tĩnh cho code có thể giúp các nhà phát triển hiểu được cấu trúc code và có thể sử dụng được code để thi hành các tiêu chuẩn mã hóa.

Các tính năng và đặc điểm của các công cụ phân tích tĩnh tập trung hỗ trợ để:

Tính toán các chỉ số như độ phức tạp hoặc mức độ nghiêm trọng (điều này có thể giúp xác định được nơi cần kiểm thử nhiều hơn do rủi ro gia tăng).

Thi hành các tiêu chuẩn mã hóa.

Phân tích cấu trúc và sự phụ thuộc.

Hỗ trợ trong việc tìm hiểu code.

Xác định các bất thường hoặc sai sót trong code.

2.3. Các công cụ mô hình hóa (modeling tools)

Các công cụ mô hình hóa giúp xác định các mô hình của hệ thống hoặc phần mềm. Ưu điểm của 2 công cụ: công cụ mô hình hóa và công cụ phân tích tĩnh là chúng có thể được sử dụng trước khi các kiểm thử động có thể chạy. Điều này cho phép bất kỳ lỗi nào mà được các công cụ này có thể xác định càng sớm thì việc sửa chữa sẽ dễ dàng và rẻ hơn. Và các giai đoạn sau đó có thể sẽ có ít lỗi hơn, do đó việc phát triển có thể được đẩy nhanh hơn và có ít các công việc phải làm lại hơn.Các tính năng và đặc điểm của các công cụ mô hình hóa bao tập trung hỗ trợ để:- Xác định xung đột và sai sót trong mô hình. - Giúp xác định và đô ưu tiên các khu vực của mô hình kiểm thử. - Dự đoán phản hồi và hành vi của hệ thống trong các tình huống khác nhau, như mức độ load trang. - Giúp hiểu được các chức năng của hệ thống và xác định được các điều kiện kiểm tra sử dụng mô hình hóa ngôn ngữ như UML.

3. Các công cụ hỗ trợ cho các chi tiết kỹ thuật test( test specification)

3.1. Các công cụ thiết kế test (test design tools).

Các công cụ thiết kế test giúp việc xây dựng các testcase hoặc ít nhất là hỗ trợ test dữ liệu đầu vào.

Các tính năng và đặc điểm của công cụ thiết kế test tập trung hỗ trợ cho:

Tạo các giá trị đầu vào kiểm thử từ:

Các yêu cầu

Mô hình thiết kế( trạng thái, dữ liệu hoặc đối tượng)

Code

Đồ họa giao diện người dùng

Các điều kiện test

Đưa đến các kết quả kỳ vọng, nếu oracle đã có sẵn trong công cụ.

Lợi ích của loại công cụ này là xác định dễ dàng và nhanh chóng các trường hợp kiểm thử( hoặc test đầu vào) và sẽ thực hiện tất cả các thành phần (ví dụ: đầu vào của các trường, các nút, các nhánh). Điều này giúp kiểm thử được kỹ lưỡng hơn. Nhưng với số lượng trường hơp test quá nhiều không thể test hết được cần phải tìm và xác định những trường hợp quan trọng nhất để chạy. Việc cắt giảm số lượng những trường hợp test không thể quản lý được thực hiện bằng cách phân tích rủi ro.

3.2. Công cụ chuẩn bị dữ liệu test (Test data preparation tools).

Việc thiết lập dữ liệu test có thể mang lại động lực đáng kể, đặc biệt nếu phạm vi hoặc khối lượng dữ liệu lớn thì việc thiết lập dữ liệu kiểm thử là cần thiết. các công cụ được sử dụng bởi các nhà phát triển trong kiểm thử chấp nhận hoặc kiểm thử hệ thống và có hữu ích cho kiểm thử hiệu năng và độ tin cậy- những nơi cần nhiều dữ liệu thực tế. Lấy dữ liệu từ cơ sở dữ liệu hiện có hoặc những cơ sở dữ liệu đã tạo, đã thao tác và chỉnh sửa cho việc sử dụng trong các bài test

Các tính năng và đặc điểm của các công cụ chuẩn bị dữ liệu test tập trung hỗ trợ để:

Trích xuất dữ liệu từ dữ liệu được lựa chọn từ các file hoặc cơ sở dữ liệu. “Massage” các bản ghi dữ liệu để các dữ liệu được ẩn đi hoặc không xác định được với người thực (để bảo vệ dữ liệu).

Cho phép các bản ghi được sắp xếp và bố trí theo một thứ tự khác.

Tạo ra các bản ghi mới với dữ liệu giả ngẫu nhiên hoặc dữ liệu được thiết lập theo một số nguyên tắc.

Xây dựng một số lượng lớn các bản ghi tương tự từ một mẫu, thiết lập số lượng bản ghi lớn cho khối lượng các bài test.

4. Công cụ hỗ trợ cho thực thi test và logging

4.1. Công cụ thực thi test (test execution tools).

Hầu hết các công cụ thực thi test đều bắt đầu bằng cách chụp hoặc ghi lại các kiểm thử thủ công do đó còn được gọi là công cụ capture/playback, công cụ capture/replay hoặc công cụ record/playback. Các công cụ thực thi test sử dụng các ngôn ngữ kịch bản để điều khiển các công cụ, nhưng các ngôn ngữ kịch bản là một ngôn ngữ lập trình. Vì vậy, bất kỳ tester nào muốn sử dụng một công cụ thực thi test trực tiếp sẽ cần cử dụng kỹ năng lập trình để tạo và sửa đổi kịch bản. Lợi thế của kịch bản lập trình là các kiểm tra có thể lặp lại hành động (trong vòng lặp) cho các giá trị dữ liệu khác nhau (vd: test các đầu vào), các kịch bản có thể lấy các route khác nhau phụ thuộc vào kết quả của các kiểm tra(nếu kiểm tra thất bại thì nên đi đến một kiểm tra khác) và có thể được gọi từ các kịch bản khác từ cấu trúc của tập hợp các kiểm tra.

Một trong những lợi ích quan trọng nhất của việc sử dụng loại công cụ này là bất cứ khi nào một hệ thống hiện có được thay đổi( ví dụ: sửa lỗi hoặc nâng cấp), tất cả các test đã chạy trước đó có thể được chạy lại để chắc chắn sự thay đổi không làm ảnh hưởng đến hệ thống.

Các tính năng và đặc điểm của các công cụ thực thi test tập trung hỗ trợ cho:

Chụp(ghi lại) đầu vào test trong khi các test được thực hiện thủ công.

Lưu trữ các kết quả kỳ vọng trên một màn hình hoặc đối tượng để so sánh trong lần kiểm tra tiếp theo.

Thực thi kiểm thử từ các kịch bản đã được lưu trữ và từ các tệp dữ liệu tùy chọn được truy cập bởi kịch bản (nếu kịch bản data-driven hoặc keyword-driven được sử dụng).

So sánh động ( test trong khi đang chạy) của các màn hình, các thành phần, các link, điều khiển, các đối tượng và các giá trị.

Khả năng thực hiện so sánh sau khi thực thi.

Kết quả khai thác của chạy test (pass/fail, sự khác biệt giữa kết quả mong đợi và kết quả thực tế).

Che đậy hoặc lọc tập hợp con của kết quả mong đợi và kết quả thực tế.

Đo thời gian của các bài test.

Đồng bộ hóa đầu vào và ứng dụng đang được kiểm tra.

Gửi kết quả tổng hợp đến một công cụ quản lý test.

4.2: Các công cụ nền tảng của kiểm thử đơn vị (unit test framework tools) và test harness.

Hai loại công cụ này được nhóm với nhau vì 2 công cụ này đều là biến thể của kiểu hỗ trợ mà các nhà phát triển cần khi kiểm tra các thành phần và đơn vị riêng lẻ.

Test harness cung cấp các stub và driver, đó là các chương trình nhỏ tương tác với phần mềm đang kiểm tra( kiểm thử phần mềm trung gian và phần mềm nhúng(embedded software)).

Công cụ nền tảng cho kiểm thử đơn vị (unit test framework tools) cung cấp sự hỗ trợ cho phần mềm hướng đối tượng( object-oriented software). Khuôn khổ của kiểm thử đơn vị có thể được sử dụng phát triển agile để kiểm thử tự động song song với sự phát triển.

Các tính năng và đặc điểm của test harnesses and unit test framework tools hỗ trợ cho:

Cung cấp đầu vào cho phần mềm đang kiểm tra.

Nhận kết quả đầu ra được tạo bởi phần mềm đang kiểm tra.

Thực thi bộ test với framework hoặc sử dụng test harnesses.

Ghi lại kết quả test (pass/fail) cho mỗi lần test (framework tool).

Lưu trữ các lần test( framework tool).

Hỗ trợ cho việc gỡ lỗi( framework tool).

Đo độ bao phủ ở mức code ( framework tool).

Một số framework hỗ trợ cho kiểm thử mức đơn vị - Selenium - Junit - TestNG

4.3. Test comparators.

Có 2 cách để so sánh kết quả thực tế của kiểm thử với kết quả kỳ vọng của kiểm thử, đó là: so sánh động(Dynamic comparison) và so sánh sau khi thực hiện(Post-execution comparison)

So sánh động có nghĩa là so sánh đươc thực hiện trong khi quá trình kiểm thử đang được thực hiện còn so sánh sau khi thực hiện có nghĩa là so sánh được thực hiện sau khi quá trình kiểm thử đã kết thúc, phần mềm kiểm thử không chạy nữa.

Các tính năng và đặc điểm của test comparator hỗ trợ để:- So sánh động của các sự kiện tạm thời xảy ra trong quá trình thực thi. - So sánh sau khi thực thi của các dữ liệu đã được lưu trữ, vd như các tập tin và cơ sở dữ liệu. - Che giấu hoặc lọc các tập con của các kết quả thực thế và kết quả kỳ vọng.

4.4. Các công cụ đo độ bao phủ (Coverage measurement tools).

Ở mức độ kiểm thử thành phần, các mục bao phủ có thể là các dòng code, các câu lệnh code hoặc kết quả quyết định. Ở mức độ tích hợp thành phần, các mục bao phủ có thể được gọi là một chức năng hoặc một module. Độ bao phủ có thể được đo tại mức kiểm thử chấp nhận hoặc kiểm thử hệ thống, ở đây độ bao phủ có thể là một báo cáo về yêu cầu.

Các tính năng và đặc điểm của công cụ đo độ bao phủ tập trung hỗ trợ để:

Xác định các loại bao phủ (instrument code).

Tính tỷ lệ phần trăm các mục bao phủ đã được thực hiện bởi một tập các kiểm tra.

Báo cáo các mục bao phủ chưa được thực hiện.

Xác định các đầu vào kiểm thử để thực hiện các mục chưa được bao phủ( chức năng công cụ thiết kế test).

Tạo ra các stub và driver ( nếu là một phần của nền tảng kiểm thử đơn vị).

Lưu ý: các công cụ bao phủ chỉ đo độ bao phủ của các mục mà chúng có thể xác định. Các kiểm tra đạt được độ bao phủ 100% không có nghĩa là phần mềm đấy đã được kiểm tra 100%.

4.5. Các công cụ bảo mật (security tools)

Các công cụ kiểm thử bảo mật có thể được sử dụng để kiểm tra bảo mật bằng cách cố xâm nhập vào một hệ thống, cho dù hệ thống đấy có được bảo vệ hay không. Các cuộc tấn công có thể tập trung vào mạng lưới, phần mềm hỗ trợ, ứng dụng code hoặc nền tảng cơ sở dữ liệu.

Các tính năng và đặc điểm của công cụ kiểm thử bảo mật tập trung hỗ trợ để:

Xác định virus.

Phát hiện xâm nhập như từ chối các tấn công dịch vụ.

Mô phỏng các kiểu tấn công bên ngoài.

Thăm dò các cổng mở hoặc các điểm có thể nhìn thấy được bên ngoài của cuộc tấn công..

Xác định điểm yếu trong các file mật khẩu và mật khẩu.

Kiểm tra bảo mật trong quá trình hoạt động, ví dụ: kiểm tra tính toàn vẹn của các file và phát hiện sự xâm nhập, kiểm tra kết quả của những lần tấn công thử.

Một số công cụ bảo mật - Wireshark (packet sniffer previously-known as Ethereal) - Metasploit (exploit) - Nessus (vulnerability scanner) - Aircrack (WEP and WPA cracker) - Snort (network intrusion detector)

5. Công cụ hỗ trợ thực hiện và giám sát.

5.1. Các công cụ phân tích động (Dynamic analysis tools )

Phân tích những gì diễn ra đằng sau trong khi phần mềm đang chạy(cho dù đang được thực hiện với các testcase hoặc đang được sử dụng để hoạt động).

Các tính năng và đặc điểm của các công cụ phân tích động tập trung hỗ trợ để:

Phát hiện rò rỉ bộ nhớ.

Xác định các lỗi con trỏ như con trỏ null.

Xác định thời gian phụ thuộc. Những công cụ này thường được sử dụng bởi các nhà phát triển trong kiểm thử thành phần và kiểm thử tích hợp thành phần.

5.2. Các công cụ kiểm thử hiệu suất(Performance-testing), Kiểm thử tải(load-testing) và kiểm thử áp lực(stress-testing).

Kiểm thử hiệu suất liên quan đến kiểm thử ở mức hệ thống để xem hệ thống có nâng mức sử dụng lên số lượng lớn được không.

Kiểm thử tải(load-testing) là kiểm tra xem hệ thống có thể chống cự được với số lượng giao dịch dự kiến.

Kiểm thử áp lực(stress-testing) là kiểm thử vượt quá mức sử dụng bình thường của hệ thống (xem điều gì sẽ xảy ra ngoài kỳ vọng thiết kế của hệ thống) có liên quan đến tải trọng hoặc khối lượng.

Trong kiểm thử hiệu suất, có rất nhiều đầu vào dùng để kiểm tra được gửi tới phần mềm hoặc hệ thống nơi các kết quả riêng biệt có thể không được kiểm tra chi tiết. Mục đích của kiểm thử là để đo các đặc tính như thời gian phản hồi, thông lượng hoặc thời gian trung bình giữa các sai sót (kiểm thử độ tin cậy). Để đánh giá hiệu suất, công cụ cần phải tạo ra một số hoạt động trên hệ thống và điều này có thể thực hiện theo những cách khác nhau, nếu hiệu suất khoogn đạt được tiêu chuẩn theo kỳ vọng thì cần thực hiện một số phân tích để xem xét vấn đề nằm ở đâu và để biết rằng phải làm những cách nào để cải thiện hiệu suất.

Các tính năng và đặc điểm của các công cụ kiểm thử hiệu suất tập trung hỗ trợ để:

Tạo ra một mức tải trọng trên hệ thống để kiểm tra.

Đo thời gian của các giao dịch cụ thể khi tải trọng trên hệ thống thay đổi.

Đo thời gian đáp ứng trung bình.

Tạo biểu đồ hoặc sơ đồ phản hồi của thời gian được thêm.

Một số công cụ hỗ trợ:

Jmeter

Webload

LoadUI Pro ...

5.3 Các công cụ giám sát(Monitoring tools).

Các công cụ giám sát được sử dụng để liên tục theo dõi tình trạng của hệ thống đang sử dụng để có những cảnh báo sớm nhất về các vấn đề hoặc để cải thiện dịch vụ. Có rất nhiều công cụ giám sát cho các máy chủ, mạng, cơ sở dữ liệu, bảo mật, hiệu suất, sử dụng website và internet và các ứng dụng.

Các tính năng và đặc điểm của các công cụ giám sát tập trung hỗ trợ để:

Xác định các vấn đề và gửi các thông báo cảnh báo cho quản trị viên (quản trị mạng).

Khai thác thông tin về thời gian thực và lịch sử.

Tìm kiếm các cài đặt tối ưu.

Giám sát số lượng người dùng trên mạng.

Giám sát lưu lượng dữ liệu trên mạng (thời gian thực hoặc bao hàm một khoảng thời gian nhất định của một hành động với phân tích được thực hiện sau đó).

6. Các công cụ hỗ trợ cho từng khu vực cụ thể

Trong phần này, chúng ta đã mô tả các công cụ theo các lớp chức năng chung. Ví dụ, có các công cụ kiểm thử hiệu suất dựa trên web cũng tốt như các công cụ kiểm thử cho các hệ thống back-office. Có nhiều công cụ phân tích tĩnh cho các nền tảng phát triển cụ thể và các ngôn ngữ lập trình, bởi vì mỗi ngôn ngữ lập trình và mỗi nền tảng đều có những đặc điểm riêng biệt. Các công cụ phân tích động tập trung vào các vấn đề bảo mật.

Mình vừa giới thiệu với các bạn một số loại công cụ được dùng để hỗ trợ kiểm thử, các tính năng và đặc điểm của từng loại công cụ hỗ trợ như thế nào trong quá trình kiểm thử. Bài viết sau mình sẽ giới thiệu một số lợi ích, rủi ro khi sử dụng các công cụ hỗ trợ kiểm thử và một số lưu ý khi sử dụng các công cụ.

https://blog.haposoft.com/kiem-thu-phan-mem-cac-cong-cu-ho-tro-cho-viec-kiem-thu-phan-2/

Kiểm thử phần mềm: Các công cụ hỗ trợ cho việc kiểm thử. (Phần 2)

duongtt

12 October 2018

software testing

Tiếp tục series tóm tắt từ cuốn sách: FOUNDATIONS OF SOFTWARE TESTING ISTQB CERTIFICATION của tác giả Dorothy Graham, Erik van Veenendaal, Isabel Evans và Rex Black và một số kinh nghiệm của cá nhân trong quá trình làm việc nhằm cung cấp cho các bạn một cái nhìn tổng quan về kiểm thử phần mềm và các kiến thức cơ bản về kiểm thử, các kỹ thuật dùng trong kiểm thử và các công cụ hỗ trợ.

Tiếp nối bài viết trước Kiểm thử phần mềm: Các công cụ hỗ trợ cho việc kiểm thử. (Phần 1) bài viết lần này mình sẽ giới thiệu với các bạn *Những lợi ích và rủi ro tiềm ẩn khi sử dụng các công cụ để hỗ trợ kiểm thử và một số lưu ý đối với các công cụ *.

1. Các lợi ích khi sử dụng các công cụ hỗ trợ kiểm thử.

Có nhiều lợi ích có thể thu được bằng cách sử dụng các công cụ hỗ trợ kiểm thử, bất kể loại công cụ nào, bao gồm:

Giảm các công việc lặp đi lặp lại.

Mọi người có xu hướng măc lỗi khi thực hiện các công việc lặp đi lặp lại nhiều lần, ví dụ như kiểm thử hồi quy, nhập các dữ liệu kiểm thử, kiểm tra các tiêu chuẩn mã hóa hoặc tạo một cơ sở dữ liệu kiểm thử cụ thể. Do vậy, một công cụ hỗ trợ kiểm thử sẽ thực hiện chính xác những gì đã làm trước đó mà không xảy ra sai sót gì.

Có tính nhất quán và tính lặp lại cao hơn.

Khi thực hiện thủ công thì con người có xu hướng làm cùng một công việc nhưng không thực hiện đúng các bước như lần kiểm tra trước đó. Một công cụ sẽ tái tạo chính xác những bước đã làm trước đó, do vậy sau mỗi lần chạy thì kết quả sẽ được nhất quán.

Đánh giá khách quan.

Nếu một người đánh giá giá trị của phần mềm, hệ thống hoặc là báo cáo sự cố, họ có thể vô tình bỏ sót vấn đề hoặc có những ý kiến chủ quan dẫn đến việc giải thích dữ liệu không chính xác. Sử dụng công cụ có nghĩa là xu hướng chủ quan sẽ bị loại bỏ và việc đánh giá tính nhất quán và lặp lại sẽ tốt hơn.

Dễ dàng để truy cập thông tin về các kiểm tra hoặc kiểm thử.

Khi sử dụng các công cụ hỗ trợ thì thông tin được trình bày trực quan, dễ hiểu hơn. Ví dụ: trình bày bằng các biểu đồ hoặc sơ đồ sẽ dễ hiểu hơn là một danh sách dài các con số. Các công cụ có mục đích đặc biệt cung cấp trực tiếp các tính năng này cho thông tin mà chúng xử lý. Ví dụ bao gồm thống kê và đồ thị về tiến độ thử nghiệm (công cụ kiểm tra hoặc công cụ kiểm tra), tỷ lệ sự cố ( công cụ quản lý sự cố hoặc công cụ quản lý kiểm tra) và hiệu suất (công cụ kiểm tra hiệu suất ).

2. Những rủi ro tiềm ẩn khi sử dụng các công cụ.

Mặc dù có những lợi ích đáng kể có thể đạt được khi sử dụng các công cụ để hỗ trợ các hoạt động kiểm thử nhưng có nhiều tổ chức chưa đạt được những lợi ích mà họ mong đợi. Mỗi loại công cụ đòi hỏi sự nỗ lực và thời gian để đạt được những lợi ích tiềm năng.

Có nhiều rủi ro khi các công cụ hỗ trợ kiểm thử được giới thiệu và sử dụng, các rủi ro bao gồm:

Kỳ vọng không thực tế cho mỗi công cụ.

Đánh giá thấp thời gian, chi phí, động lực cho việc giới thiệu ban đầu của công cụ.

Đánh giá thấp thời gian và động lực cần thiết để đạt được những lợi ích có ý nghĩa và những lợi ích kéo dài của công cụ.

Đánh giá thấp động lực cần thiết để duy trì các giá trị kiểm thử được tạo ra bởi công cụ.

Quá phụ thuộc vào công cụ.

Những kỳ vọng không thực tế có thể là một trong những rủi ro lớn nhất cho sự thành công của các công cụ. Điều quan trọng là phải có mục tiêu rõ ràng, các công cụ có thể làm được những gì và những mục tiêu đấy phải thực tế. Chắc chắn 1 công cụ có thể trợ giúp nhưng không thể thay thế sự thông minh của con người biết cách sử dụng nó tốt nhất và đánh giá được khả năng sử dụng của nó trong hiện tại và tương lai.

Danh sách rủi ro chưa được nghiên cứu, có 2 yếu tố quan trọng khác là:

Các kỹ năng cần thiết để tạo nên các kiểm tra tốt.

Các kỹ năng cần thiết để sử dụng tốt công cụ, tùy thuộc vào loại công cụ.

Các kỹ năng của một tester không giống với các kỹ năng của người sử dụng công cụ. Tester tập trung vào những những vấn đề cần kiểm thử, những testcase cần test và những kiểm thử được ưu tiên như thế nào. Còn người sử dụng công cụ thì tập trung vào cách làm thế nào để công cụ làm việc một cách hiệu quả và làm thế nào để làm tăng lợi nhuận từ việc sử dụng công cụ.

3. Một số lưu ý đối với một vài công cụ

3.1. Công cụ thực thi test.

Các công cụ thực thi test sẽ cho chúng ta biết phải thực hiện test những gì và chạy chúng như thế nào, nhờ vào các kịch bản, vì vậy cần lưu ý các mức kịch bản khác nhau:

Kịch bản tuyến tính(linear scripts)( có thể tạo bằng tay hoặc bắt được bằng cách ghi lại các thao tác test thủ công).

Các kịch bản có cấu trúc (sử dụng các cấu trúc lập trình lặp và lựa chọn).

Các kịch bản chia sẻ ( nơi một kịch bản có thể được gọi bởi các kịch bản khác vì vậy có thể tái sử dụng - các kịch bản chia sẻ cũng yêu cầu một thư viện kịch bản chính thức dưới quản lý cấu hình).

Các kịch bản data-driven ( nơi dữ liệu test nằm trong các tệp hoặc bảng tính được đọc bởi một kịch bản điều khiển).

Các kịch bản keyword-driven(nơi mà tất cả các thông tin về các kiểm tra được lưu trữ.

Kịch bản mà không biết kết quả mong đợi là gì cho đến khi được lập trình-nó chỉ chứa các đầu vào được ghi lại, chứ không phải các testcase.

Một sự thay đổi nhỏ cho phần mềm có thể làm hàng trăm, hàng chục kịch bản bị vô hiệu.

Những kịch bản được ghi lại chỉ có thể đối phó với chính xác những điều kiện giống khi nó được ghi lại. Những sự kiện không mong đợi sẽ không được công cụ diễn tả chính xác.

3.2. Công cụ kiểm thử hiệu suất.

Đối với công cụ kiểm thử hiệu suất cần lưu ý những vấn đề sau:

Dự kiến về tải trọng của công cụ (vd: các đầu vào ngẫu nhiên hoặc theo hồ sơ người dùng).

Các khía cạnh về thời gian (vd: chèn độ trễ để tạo các đầu vào của người dùng được mô phỏng thực tế hơn).

Độ dài của kiểm thử và nên làm gì nếu kiểm thử kết thúc sớm.

Thu hẹp vị trí nút thắt ( bottleneck)

Xác định chính xác những khía cạnh nào cần đo lường (vd: cấp độ tương tác của người dùng hoặc cấp độ server)

Trình bày những thông tin thu thập được như thế nào.

3.3. Công cụ phân tích tĩnh.

Những vấn đề cần lưu ý khi sử dụng các công cụ phân tích tĩnh.

Khi sử dụng các công cụ phân tích mới thì sẽ xảy ra một số vấn đề, Ví dụ: công cụ kiểm tra tiêu chuẩn mã hóa hiện tại đối với code đã được viết cách đây vài năm, có thể sẽ tìm thấy những thứ trong code cũ không đáp ứng được tiêu chuẩn mã hóa mới.

Khi thay đổi để đáp ứng với tiêu chuẩn mã hóa mới có thể xảy ra những tác động phụ không mong đợi.

Các công cụ phân tích tĩnh có thể tạo ra một số lượng lớn các thông điệp và bộ lọc trên đầu ra của công cụ phân tích tĩnh có thể loại bỏ một số thông điệp ít quan trọng và làm cho các thông điệp quan trọng được chú ý và cố định hơn.

3.4. Công cụ quản lý test.

Những vấn đề cần lưu ý khi sử dụng các công cụ quản lý test.

Công cụ quản lý test có thể cung cấp nhiều thông tin hữu ích nhưng thông tin được cung cấp không ở dạng có hiệu quả nhất trong ngữ cảnh của người sử dụng.

Sử dụng bảng tính hoặc một số công việc bổ sung tạo giao diện cho các công cụ để đảm bảo thông tin được truyền đạt hiệu quả.

Báo cáo được tạo ra bởi công cụ quản lý test chỉ có hữu ích trong thời điểm hiện tại nhưng trong tương lai thì có thể không có ích.

Cần phải có một quy trình kiểm tra xác định trước khi sử dụng các công cụ quản lý kiểm thử.

Nếu quá trình kiểm thử đang hoạt động tốt theo cách thủ công thì công cụ quản lý test có thể hỗ trợ quy trình và làm cho nó hoạt động hiệu quả hơn.

Nếu áp dụng công cụ quản lý test khi quá trình kiểm thử chưa hoàn thành thì phải tuân theo các tiêu chuẩn và quy trình được giả định theo cách công cụ hoạt động.

Trên đây là một số lợi ích, rủi ro và một số chú ý khi sử dụng công cụ hỗ trợ kiểm thử. Các bạn có thể tham khảo và có thể lựa chọn được công cụ hỗ trợ thích hợp để tăng lợi ích, giảm thiểu rủi ro đối với sản phẩm của mình.

https://blog.haposoft.com/kiem-thu-hieu-nang/

# Kiểm thử hiệu năng - Tạo kế hoạch kiểm thử hiệu năng đơn giản (Phần 1)

###### Nguyễn Xuân Lâm

09 October 2018

software testing

Ở phần trước, Chúng ta đã biết Jmeter là gì? Jmeter dùng để làm gì? và cài đặt nó thế nào? Ở phần này, chúng ta sẽ tìm hiểu JMeter Performance Testing

## JMeter Performance Testing:

JMeter Performance Testing bao gồm:

Load testing: Mô hình hóa dự kiến sử dụng bởi nhiều người dùng truy cập một dịch vụ website trong cùng thời điểm.

Stress testing: Tất cả các web server có thể tải một dung lượng lớn, khi mà tải trọng vượt ra ngoài giới hạn thì web server bắt đầu phản hồi chậm và gây ra lỗi. Mục đích của stress testing là có thể tìm ra độ tải lớn mà web server có thể xử lý.

### 1. Thêm Thread Group

Bước 1: Click chuột phải vào Test Plan > Add > Threads (Users) > Thread Group

Bước 2: Trên cửa sổ Thread Group ta thực hiện nhập Thread properties như sau:

Name: Tên thread group

Number of Threads - Số lượng người sử dụng truy cập vào website: 100

Ramp-Up Period: 100

Loop Count - Số thời gian thực hiện kiểm tra: 5

(Ramp-Up cùng với Number of Threads sẽ chỉ ra được thời gian trì hoãn trước khi một người dùng tiếp theo bắt đầu sử dụng. Ví dụ: Nếu chúng ta có 100 người dùng và Ram-up 100 giây thì sự chậm trễ giữa những người dùng sẽ là 1 giây.)

### 2. Thêm phần tử Jmeter

HTTP request default

Click chuột phải vào Thread Group mới tạo > Add > Config Element > HTTP Request Defaults

Trên cửa sổ HTTP Request Defaults ta nhập tên Website

HTTP Request

Click chuột phải vào Thread Group "Kiểm tra hiệu năng" > Add > Sampler > HTTP Request

Trên cửa sổ HTTP Request, trường Path sẽ chỉ ra URL request nào bạn muốn gửi tới máy chủ:

Nếu để trống JMeter sẽ tạo URL request http://vietnamnet.vn/ tới máy chủ

Nếu muốn tạo URL request http://vietnamnet.vn/vn/thoi-su/ thì nhập: vn/thoi-su/

### 3. Thêm Graph result

Hiển thị kết quả dưới dạng biểu đồ

Click chuột phải vào Thread Group Kiểm tra hiệu năng > Add > Listener > Graph Results

### 4. Chạy và lấy kết quả

Click button "Start" hoặc Ctrl + R để chạy ta có kết quả như sau:

### 5. Phân tích kết quả

Để phân tích Performance của Web server, ta tập trung vào hai thông số: Throughput và Deviation.

Throughput là thông số quan trọng nhất, nó miêu tả cho khả năng server có thể xử lý được độ tải lớn.

Deviation thể hiện sự sai lệch hiện tại so với mức trung bình, thông số này càng nhỏ thì càng tốt.

Đọc kết quả test trang vietnamnet:

Throughput của máy chủ Vietnamnet là 300.939/phút. Tức là, máy chủ Vietnamnet có thể xử lý 304 019 yêu cầu trên mỗi phút.

Deviation của Vietnamnet là 16.

Như vậy, chúng ta đã vừa hoàn thành 1 bước kiểm thử hiệu năng đơn giản.

Cảm ơn các bạn đã theo dõi

https://blog.haposoft.com/kiem-thu-hieu-nang-aggregate-report/

Kiểm thử hiệu năng - Aggregate Report (Phần 2)

Nguyễn Xuân Lâm

11 October 2018

software testing

Aggregate Report là một report rất hữu ích của Jmeter

1. Các số liệu trong report:

Mọi người có thể thấy Aggregate Report là 1 report dạng table, với 12 columns ứng với 12 thông số. Chúng ta sẽ tìm hiểu xem ý nghĩa của từng thông số nhé!

• Label: Hiển thị tên của từng requests có trong test plan của bạn.

Mặc định, tất cả những request bị trùng tên trong test plan, sẽ chỉ hiển thị 1 dòng duy nhất trong table này, cho dù nội dung của các request đó có khác nhau hay nằm khác Thread Group đi chăng nữa. Vì vậy, khi đặt tên cho các Request, mọi người lưu ý nhớ điều này, và đặt tên khác nhau

Ở cuối màn hình, chúng ta để ý sẽ thấy có checkbox “Include group name in the label?”. Nếu tích chọn “Include group name in the label?” thì lable request sẽ được gán thêm tiền tố tên của Thread Group chứa request đó.

• #Samples: Tổng số lần run của request. Công thức:

Samples = Number of Threads (users) * Loop Count

Ví dụ 1: Thread Group có cấu hình– Number of Threads (users): 100 – Loop Count: 5 Thì 1 HTTP Request của Thread Group này sẽ run 100 x 5 = 300 (lần)—> #Samples: 500

Tuy nhiên, công thức trên sẽ không còn đúng trong 1 số trường hợp: đó là khi Request của bạn nằm bên dưới 1 Logic Controller nào đó, chẳng hạn như Logic Controller, such as Loop Controller, Once Only Controller, While Controller,.. (Chúng ta sẽ tìm hiểu dần)Ví dụ 2: Tiếp tục với ví dụ 1 ở trên, nhưng lần này thì hãy để HTTP Request vào 1 Logic Controller, là Loop Controller, và để giá trị Loop Count cho controller này là 2. Lúc này request của bạn sẽ run: 100 x 5 x 2 = 1000 (lần).—> #Samples: 1000 • Average (millisecond): Thời gian phản hồi trung bình (Response Time) của request, tính cho đến lần run cuối cùng.

Ví dụ 3: Một Request A run tổng cộng 3 lần với các kết quả Response Time tương ứng là 41ms, 46ms, 56ms thì Response Time trung bình của Request A sẽ là ~47.68

• Min (millisecond): Respone Time thấp nhất của request tính cho toàn bộ tất cả các lần run.

Trong ví dụ 3 ở trên thì Min = 41ms

• Max (millisecond): Respone Time cao nhất của request tính cho toàn bộ tất cả các lần run.

Trong ví dụ 3 ở trên thì Max = 56ms

• Percentiles (millisecond): Ở đây chùng ta cần hiểu Percentiles là j để có thể hiểu được các phần sau Percentiles mọi người cũng đừng hiểu nó là phần trăm (%). Percentiles sẽ là một con số x, và đi kèm theo 1 giá trị A. Nghĩa là sẽ có x% có giá trị thấp hơn giá trị A, còn lại (100-x)% sẽ có giá trị lớn hơn giá trị A. Ví dụ: Lớp bạn có 100 người làm bài kiểm tra, Giảng viên nói bạn có Percentile là 60% có nghĩa là: Trong tất cả học sinh trong lớp (100 người) có 60 người (Tương đương 60%) có điểm thấp hơn bạn và 40 người (40%) có điểm cao hơn bạn

Median (millisecond): Nó gần giống với trung bình, nhưng ý nghĩa thì khác hoàn toàn. Median + một giá trị A, sẽ chia toàn bộ các giá trị của bạn thành 2 phần bằng nhau, một phần sẽ chứa những giá trị < A, phần còn lại sẽ chứa những giá trị > A. Median cũng được hiểu như là 50th Percentile. Quay lại Performance, thì Median sẽ chỉ ra, sẽ có 50% số request có response time nhỏ hơn giá trị (hiển thị trên table), và 50% số request còn lại có response time lớn hơn giá trị này

90% Line (90th Percentile) (millisecond):nghĩa là 90% số requests sẽ có response time nhỏ hơn giá trị hiển thị trong table, 10% số requests còn lại sẽ có response time lớn hơn giá trị hiển thị trong table

95% Line (90th Percentile) (millisecond):nghĩa là 95% số requests sẽ có response time nhỏ hơn giá trị hiển thị trong table, 5% số requests còn lại sẽ có response time lớn hơn giá trị hiển thị trong table

99% Line (90th Percentile) (millisecond):nghĩa là 99% số requests sẽ có response time nhỏ hơn giá trị hiển thị trong table, 1% số requests còn lại sẽ có response time lớn hơn giá trị hiển thị trong table

• Error %: % số lượng request bị fail, bị lỗi. Ví dụ bạn run request A 100 lần và thấy có 15% errors, nghĩa là request A đã fail/error 15 lần (100*15%)

• Throughput: Thông lượng. Con số này cho bạn biết được số lượng requests được hệ thống (server) xử lý trong 1 đơn vị thời gian, có thể là giây, phút, hoặc giờ.

Công thức tính throughput là:

Throughput = (Tổng số lượng requests) / (Tổng thời gian) * (Đơn vị chuyển đổi)

Với:- Tổng số lượng requests = Tổng số lần request này được run - Tổng thời gian = (Thời gian bắt đầu chạy của request cuối cùng) + (Thời gian chạy/Response Time của request cuối cùng) - (Thời gian bắt đầu chạy của request đầu tiên) - Đơn vị chuyển đổi: Mặc định nó sẽ tính theo millisecond, nên để đổi về second thì số này sẽ là 1000, hoặc 1000*60 nếu bạn muốn chuyển về phút.

Lưu ý: Đối với JMeter thì nó luôn luôn hiển thị Throughput > 1.0, vì vậy trong 1 số trường hợp số này < 1.0 thì nó sẽ convert qua 1 đơn vị khác để hiển thị. Ví dụ 0.5 requests/second, 0.5 ko thoả điều kiện, nên nó sẽ hiển thị là 30requests/min. • KB/sec: Cũng là thông lượng, nhưng ko đo lường bằng số request, mà đo Kilobytes/second. Công thức là

Throughput KB/sec = (Throughput * Average Bytes) / 1024

Với Aggregate Report thì mình không thấy được thông số Average Bytes. Bạn có thể xem thông số này từ Summay Report.

• Total: Trong report có 1 dòng cuối cùng đó là Total, nó sẽ tổng kết lại toàn bộ kết quả từ những request bên trên. Ngoại trừ # Samples, Throughput và KB/sec, nó sẽ được cộng lại theo đúng nghĩa "Total". Còn các thông số còn lại đều được tính Total bằng cách lấy giá trị trung bình từ tất cả những request ở trên.

2. Phân tích report

Chúng ta sẽ trung vào 2 thông số quan trọng nhất của mọi Performance Report:

Response Time: chỉ ra được việc xử lý request NHANH hay CHẬM. Và đương nhiên, Response Time thì phải càng THẤP càng tốt.

Throughput: chỉ ra được số lượng requests được server xử lý trong một đơn vị thời gian. Vậy thì, cùng một thời gian, càng xử lý được càng nhiều càng tốt. Nên với Throughput thì nó phải càng CAO càng tốt

Chúng ta có những trường hợp như sau:

Response Time: THẤP và Throughput: THẤP --> Trường hợp này sẽ không bao giờ xảy ra. Vì Response Time THẤP nghĩa là thời gian đáp ứng rất nhanh, nhưng Throughput THẤP lại chỉ ra rằng số request được xử lý rất ít. Noooo, chuyện này là vô lý

Response Time: THẤP and Throughput: CAO --> Đây là một kết quả lý tưởng. Thời gian xử lý thấp và số lượng request xử lý cùng đồng thời lại cao. Như vậy có thể thấy rằng Server đang rất tốt. Hãy xem xét khả năng mở rộng các tính năng, hoặc tăng thêm số lượng test để tìm xem giới hạn của server là bao nhiêu.

Response Time: CAO and Throughput: THẤP --> Ngược lại với bên trên, đây là lúc mà Performance Test của bạn đã bị fail. Test chỉ ra rằng thời gian xử lý quá cao, và lượng request được xử lý lại rất thấp. Phải xem xét để improve về phía sever side.

Response Time: CAO and Throughput: CAO --> Khá nhạy cảm, vì bạn có thể thấy Throughput cao, tức là server đang làm việc rất tốt, vậy tại sao thời gian xử lý lại cũng cao (không tốt). Có thể vấn đề lúc này đế từ phía Client, hoặc cụ thể là đến từ JMeter, có thể đoạn script của bạn viết chưa được tối ưu, khiến quá trình nó xử lý mất nhiều thời gian chẳng hạn? ... Bạn hãy kiểm tra lại để chắc chắn rằng mình có một kết quả test chính xác.
