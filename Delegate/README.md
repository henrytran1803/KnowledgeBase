### DELEGATE pattern
Delegate pattern là một design pattern là _messaging design pattern_ trong Swift.
ược sử dụng trong việc giao tiếp 1-1 hoặc là 1- n  giữa những object, tận dụng `protocol` trong Swift để ủy thác cho một object.
Một ví dụ để hiểu thêm về Delegate
Tạo một protocol 
~~~ swift
// delegate count
protocol CounterDelegate {
// func increment
    func increment() -> Void

}
~~~

Một class counter sẽ kế thừa từ protocol CouterDelegate
~~~swift

class Counter: CounterDelegate {

    private** var value: Int = 0 {

        didSet { print("Counter value: \(value)") }

    }

  

    func increment() {

        self.value += 1

    }

}
~~~

Một class khác sẽ là lớp dùng để điều khiển lớp counter

~~~swift
class Control {

    private var delegate: CounterDelegate

  

    init(delegate: CounterDelegate) {

        self.delegate = delegate

    }

  

    func buttonClicked() {

        self.delegate.increment()

    }

}
~~~
Thực hiện chạy thử
~~~swift
// Khởi tạo Counter
let counter = Counter()
// khởi tạo control truyền delegate counter vào
let control = Control(delegate: counter)

  
// gọi tăng một đơn vị
control.buttonClicked()

// Counter value: 1

control.buttonClicked()

// Counter value: 2

control.buttonClicked()
~~~

Kết quả khi gọi tăng 3 lần thì obj từ lớp counter được giao trọng trách cho control làm tăng lên 3

RxSwift và Moya là hai thư viện khác nhau trong phát triển iOS, nhưng chúng thường được sử dụng cùng nhau trong các dự án Swift để xây dựng các ứng dụng reactive và dễ mở rộng. Dưới đây là sự khác biệt và cách học của từng thư viện:

### **1. RxSwift**

RxSwift là một thư viện giúp bạn viết code theo kiểu lập trình reactive (reactive programming). Nó cho phép bạn xử lý các luồng sự kiện và dữ liệu không đồng bộ (asynchronous) một cách dễ dàng và có thể dự đoán. Các khái niệm chính của RxSwift bao gồm **Observable, Observer, Operator,** và **Scheduler**.

#### **Cách học RxSwift:**

- **Hiểu các khái niệm cơ bản:** Bắt đầu với các khái niệm như Observable và Observer. Học cách tạo và quan sát các Observable.
- **Học về Operators:** Các Operators là các công cụ mạnh mẽ trong RxSwift để chuyển đổi và xử lý dữ liệu.
- **Thực hành với các ví dụ đơn giản:** Bắt đầu với các ví dụ nhỏ, như xử lý các sự kiện từ UI (như nhấn nút) hoặc xử lý các phản hồi từ API.
- **Sử dụng trong dự án thực tế:** Áp dụng RxSwift trong các dự án để hiểu sâu hơn về cách quản lý dữ liệu không đồng bộ và các trạng thái phức tạp trong ứng dụng.

### **2. Moya**

Moya là một thư viện wrapper trên Alamofire, giúp đơn giản hóa việc thực hiện các yêu cầu mạng (network requests) trong Swift. Nó cung cấp một cách tiếp cận có cấu trúc hơn để quản lý các yêu cầu API, giúp code dễ bảo trì và mở rộng hơn.

#### **Cách học Moya:**

- **Hiểu cách làm việc với API:** Học cách định nghĩa các mục tiêu API (API targets) và cách sử dụng Moya để thực hiện các yêu cầu mạng.
- **Tích hợp với RxSwift:** Học cách kết hợp Moya với RxSwift để thực hiện các yêu cầu mạng một cách reactive.
- **Xây dựng các lớp dịch vụ (service layers):** Tạo các lớp dịch vụ để quản lý và tổ chức các yêu cầu API trong ứng dụng của bạn.

### **Kết hợp RxSwift và Moya:**

Khi bạn đã quen với cả hai thư viện, bạn có thể kết hợp chúng để xây dựng các ứng dụng reactive mà vẫn dễ dàng quản lý và mở rộng. RxSwift sẽ xử lý luồng dữ liệu và sự kiện, trong khi Moya đảm bảo rằng các yêu cầu mạng của bạn được thực hiện một cách hiệu quả.

#### **Lộ trình học:**

1. **Bắt đầu với RxSwift:** Nắm vững các khái niệm và cách sử dụng RxSwift.
2. **Chuyển sang Moya:** Học cách thực hiện các yêu cầu mạng đơn giản bằng Moya.
3. **Tích hợp RxSwift và Moya:** Thực hành xây dựng một ứng dụng nhỏ sử dụng cả hai thư viện.

Nếu bạn đã có kinh nghiệm với các khái niệm mạng và lập trình reactive, thì việc học song song cả hai thư viện sẽ mang lại lợi ích lớn cho bạn trong việc phát triển ứng dụng Swift phức tạp hơn.

4o