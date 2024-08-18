// MARK: Single Responsibility Principle (SRP)
//
    //Note
    //guyên lý trách nhiệm duy nhất: Mỗi lớp nên chỉ có một lý do để thay đổi, tức là nó chỉ nên có một trách nhiệm duy nhất.
//

import UIKit
struct Product{
    var price: Double
}

/*
 Vi phạm S vì Invoice vi có quá nhiều việc nhiều trách nhiệm bên trong
 
struct Invoice {
    var products: [Product]
    let id: String = NSUUID().uuidString
    var percentageDiscount: Double
    
    var total: Double {
        let totalAmount = products.map({ $0.price }).reduce(0, +)
        let discountAmount = totalAmount * percentageDiscount / 100
        return totalAmount - discountAmount
    }
    func printInvoice() {
        print("-----------------")
        print("Invoice \(id)")
        print("Discount \(percentageDiscount)")
        print("Total \(total)")
        print("-----------------")
    }
    func saveToDB(){
        
    }
}
*/

// Cách S thì tách nó ra thành từng phần mỗi phần có một nhiệm vụ khác nhau
struct Invoice {
    var products: [Product]
    let id: String = NSUUID().uuidString
    var percentageDiscount: Double
    
    var total: Double {
        let totalAmount = products.map({ $0.price }).reduce(0, +)
        let discountAmount = totalAmount * percentageDiscount / 100
        return totalAmount - discountAmount
    }
    
    // cách tôi ưu hơn thay vì khởi tạo struct mới truyền invoice vào thì ta làm vậy để gọi cho tối ưu
    func printInvoice() {
       let printer = PrintInvoice(invoice: self)
        printer.printInvoice()
    }
    func saveToDB(){
        let save = SaveInvoice(invoice: self)
        save.saveToDB()
    }
}

struct PrintInvoice{
    var invoice: Invoice
    
    func printInvoice() {
        print("-----------------")
        print("Invoice \(invoice.id)")
        print("Discount \(invoice.percentageDiscount)")
        print("Total \(invoice.total)")
        print("-----------------")
    }
}
struct SaveInvoice{
    var invoice: Invoice
    
    func saveToDB(){
        
    }
}
let products: [Product] = [.init(price: 10), .init(price: 30), .init(price: 100)]
let invoice = Invoice(products: products, percentageDiscount: 10)

// cách 1 chưua tối ưu
let printer = PrintInvoice(invoice: invoice)
printer.printInvoice()

// cách 2
invoice.printInvoice()


// MARK: - Open/Closed Principle (OCP)
// Note:
// Nguyên lý mở/đóng: Các thực thể phần mềm (lớp, module, hàm, v.v.) nên được mở để mở rộng nhưng đóng để sửa đổi.

// Base (Vi phạm OCP)
/*
struct InvoicePersistenceOCP {
    let invoice: Invoice
    
    func saveToCoreData(){
        print("save to core data \(invoice.id)")
    }
    func saveToFirebase(){
        print("save to firebase \(invoice.id)")
    }
}
*/
// Trên đây là cách tiếp cận không tuân thủ OCP. Nếu muốn lưu hóa đơn vào một hệ thống khác (ví dụ như lưu vào file), chúng ta cần sửa đổi lớp `InvoicePersistenceOCP`, vi phạm nguyên lý OCP.

// Solution (Tuân thủ OCP)

struct InvoicePersistenceOCP {
    let persistence: InvoicePersistable
    
    // `save(invoice:)` là một phương thức duy nhất để lưu hóa đơn. Nó không cần phải thay đổi khi bạn muốn lưu vào một hệ thống mới.
    func save(invoice: Invoice){
        persistence.save(invoice: invoice)
    }
}

// Giao thức `InvoicePersistable` định nghĩa một giao diện trừu tượng cho các lớp thực thi. Bất kỳ lớp nào tuân thủ giao thức này đều có thể thực hiện lưu hóa đơn mà không cần thay đổi lớp `InvoicePersistenceOCP`.
protocol InvoicePersistable {
    func save(invoice: Invoice)
}

// Lớp `CoredataPersistence` là một implementation cụ thể của giao thức `InvoicePersistable`. Nó thực hiện chức năng lưu hóa đơn vào Core Data.
struct CoredataPersistence: InvoicePersistable {
    func save(invoice: Invoice) {
        print("save to core data \(invoice.id)")
    }
}

// Lớp `FirebasePersistence` là một implementation cụ thể khác của giao thức `InvoicePersistable`. Nó thực hiện chức năng lưu hóa đơn vào Firebase.
struct FirebasePersistence: InvoicePersistable {
    func save(invoice: Invoice) {
        print("save to firebase \(invoice.id)")
    }
}

// Sử dụng
let coredata = CoredataPersistence()  // Chọn phương pháp lưu vào Core Data
let persistenceOCP = InvoicePersistenceOCP(persistence: coredata)
persistenceOCP.save(invoice: invoice)  // Lưu hóa đơn bằng phương pháp đã chọn


// MARK: - Liskov Substitution Principle (LSP)
// Note:
// Nguyên lý thay thế Liskov: Các đối tượng của một lớp con nên có thể thay thế cho các đối tượng của lớp cha mà không làm thay đổi tính đúng đắn của chương trình.

// Lớp cơ sở `CustomError`
class CustomError: Error {
    var message: String
    
    init(message: String) {
        self.message = message
    }
    
    func handleError() {
        print("Handling error: \(message)")
    }
}

// Sử dụng
let error: CustomError = CriticalErrorLSP(message: "Something went wrong", errorCode: 500)
error.handleError()  // Đảm bảo hành vi đúng như mong đợi


// Lớp con `CriticalError` (vi phạm LSP)
class CriticalError: CustomError {
    var errorCode: Int
    
    init(message: String, errorCode: Int) {
        self.errorCode = errorCode
        super.init(message: message)
    }
    
    override func handleError() {
        // Không làm gì cả, thay đổi hành vi của lớp cha
        // Điều này có thể gây ra vấn đề nếu người sử dụng mong đợi `handleError` phải được gọi.
    }
}

// Sử dụng
let error1: CustomError = CriticalError(message: "Something went wrong", errorCode: 500)
error1.handleError()  // Đây sẽ không xử lý lỗi như mong đợi

// Lớp con `CriticalError` (tuân thủ LSP)
class CriticalErrorLSP: CustomError {
    var errorCode: Int
    
    init(message: String, errorCode: Int) {
        self.errorCode = errorCode
        super.init(message: message)
    }
    
    override func handleError() {
        // Gọi `handleError` của lớp cha để đảm bảo hành vi nhất quán
        super.handleError()
        print("Critical error code: \(errorCode)")
    }
}


// MARK: - Interface Segregation Principle (ISP)
// Note:
// Nguyên lý phân tách giao diện: Nhiều giao diện cụ thể tốt hơn là một giao diện chung chung.
// Điều này giúp các lớp chỉ cần triển khai những phương thức mà chúng thực sự cần dùng,
// tránh việc phải triển khai các phương thức không cần thiết.

// Trước khi áp dụng ISP
protocol GestureProtocol {
    func didTap()
    func diddoubleTap()
    func didLongTap()
}

// Ví dụ trên vi phạm ISP:
// Các lớp triển khai `GestureProtocol` phải cài đặt tất cả các phương thức, ngay cả khi chúng không cần thiết.
// Điều này có thể dẫn đến các phương thức rỗng, không có chức năng thực tế, làm tăng độ phức tạp và giảm tính linh hoạt của mã.
/*
struct Button: GestureProtocol {
    func didTap() {
        // Button này có chức năng xử lý tap
    }
    
    func diddoubleTap() {
        // Button này không cần xử lý double tap
    }
    
    func didLongTap() {
        // Button này không cần xử lý long tap
    }
}

struct ButtonSingleDoubleTao: GestureProtocol {
    func didTap() {
        // Button này chỉ cần xử lý tap
    }
    
    func diddoubleTap() {
        // Button này xử lý double tap
    }
    
    func didLongTap() {
        // Button này không cần xử lý long tap
    }
}
*/

// Sau khi áp dụng ISP:
// Thay vì có một giao diện lớn `GestureProtocol`, chúng ta chia nó thành ba giao diện nhỏ hơn, mỗi giao diện tập trung vào một hành động cụ thể.
protocol GestureLongProtocol {
    func didLongTap()
}

protocol GestureDidProtocol {
    func didTap()
}

protocol GestureDoubleProtocol {
    func diddoubleTap()
}

// Bây giờ, các lớp chỉ cần triển khai các giao diện mà chúng thực sự cần.

struct Button: GestureLongProtocol, GestureDidProtocol, GestureDoubleProtocol {
    func didTap() {
        // Xử lý tap
    }
    
    func diddoubleTap() {
        // Xử lý double tap
    }
    
    func didLongTap() {
        // Xử lý long tap
    }
}

// `ButtonSingleDoubleTao` chỉ cần xử lý double tap, nên nó chỉ triển khai giao diện `GestureDoubleProtocol`.
struct ButtonSingleDoubleTao: GestureDoubleProtocol {
    func diddoubleTap() {
        // Xử lý double tap
    }
}

// MARK: - Dependency Inversion Principle (DIP)
// Note:
// Nguyên lý đảo ngược sự phụ thuộc: Các mô-đun cấp cao không nên phụ thuộc vào các mô-đun cấp thấp. Cả hai nên phụ thuộc vào các giao diện trừu tượng.
// Các nguyên lý này giúp lập trình viên thiết kế hệ thống phần mềm dễ bảo trì, dễ mở rộng và ít lỗi.

// Lớp `EmailService` chịu trách nhiệm gửi email
class EmailService {
    func sendEmail(to recipient: String, message: String) {
        print("Sending email to \(recipient) with message: \(message)")
    }
}

// Lớp `Notification` sử dụng `EmailService` để gửi thông báo
class Notification {
    private let emailService = EmailService()
    
    func sendNotification(to recipient: String, message: String) {
        emailService.sendEmail(to: recipient, message: message)
    }
}

// Sử dụng lớp `Notification`
let notification = Notification()
notification.sendNotification(to: "user@example.com", message: "You have a new message")
//Mã vi phạm DIP: Lớp Notification trực tiếp phụ thuộc vào lớp EmailService.
//Điều này vi phạm DIP vì Notification không thể dễ dàng mở rộng hoặc thay
//đổi cách gửi thông báo (ví dụ, thay thế bằng một dịch vụ SMS) mà không phải sửa đổi mã của Notification.

// Tạo một giao diện `MessageService` để trừu tượng hóa việc gửi thông báo
protocol MessageService {
    func sendMessage(to recipient: String, message: String)
}

// Lớp `EmailService` tuân thủ giao diện `MessageService`
class EmailService: MessageService {
    func sendMessage(to recipient: String, message: String) {
        print("Sending email to \(recipient) with message: \(message)")
    }
}

// Lớp `SMSService` cũng tuân thủ giao diện `MessageService` để gửi tin nhắn SMS
class SMSService: MessageService {
    func sendMessage(to recipient: String, message: String) {
        print("Sending SMS to \(recipient) with message: \(message)")
    }
}

// Lớp `Notification` không còn phụ thuộc trực tiếp vào `EmailService` mà phụ thuộc vào `MessageService`
class Notification {
    private let messageService: MessageService
    
    init(messageService: MessageService) {
        self.messageService = messageService
    }
    
    func sendNotification(to recipient: String, message: String) {
        messageService.sendMessage(to: recipient, message: message)
    }
}

// Sử dụng lớp `Notification` với `EmailService`
let emailNotification = Notification(messageService: EmailService())
emailNotification.sendNotification(to: "user@example.com", message: "You have a new email")

// Sử dụng lớp `Notification` với `SMSService`
let smsNotification = Notification(messageService: SMSService())
smsNotification.sendNotification(to: "user@example.com", message: "You have a new SMS")
