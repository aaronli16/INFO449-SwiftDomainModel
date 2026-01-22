struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount = 0
    var currency = ""
    
    
    
    public func convert(_ currency : String) -> Money{
        var amountInUSD: Double
        var finalAmount: Double
        
        // converting to usd
        switch self.currency {
        case "USD":
            amountInUSD = Double(self.amount)
        case "GBP":
            amountInUSD = Double(self.amount) * 2.0
        case "EUR":
            amountInUSD = Double(self.amount) * (2.0/3.0)
        case "CAN":
            amountInUSD = Double(self.amount) * (4.0/5.0)
        default:
            fatalError("Unknown currency")
        }
        
        // convert to wanted currency
        switch currency {
        case "USD":
            finalAmount = amountInUSD
        case "GBP":
            finalAmount = amountInUSD * 0.5
        case "EUR":
            finalAmount = amountInUSD * (3.0/2.0)
        case "CAN":
            finalAmount = amountInUSD * (5.0/4.0)
        default:
            fatalError("Unknown currency")
        }
        
        return Money(amount: Int(finalAmount), currency: currency)
    }
    
    public func add(_ arg : Money) -> Money{
        let convertedAmount = self.convert(arg.currency) // making sure they're same currency
        return Money(amount: Int(convertedAmount.amount + arg.amount), currency: arg.currency)
    }
    
    public func subtract(_ arg : Money) -> Money{
        let convertedAmount = self.convert(arg.currency) // making sure they're same currency
        return Money(amount: Int(convertedAmount.amount - arg.amount), currency: arg.currency)
    }
}


////////////////////////////////////
// Job
//
public class Job {
    public var title = ""
    public var type: JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    public init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public func calculateIncome(_ hour : Int) -> Int {
        var income = 0
        
        
        switch self.type {
        case .Hourly(let pay):
            income = Int(Double(hour) * pay)
        case .Salary(let pay):
            income = Int(pay)
        }
        return income
    }
    
    public func raise(byAmount: Double){
        switch self.type {
        case .Hourly(let pay):
            self.type = .Hourly(pay + byAmount)
        
        case .Salary(let pay):
            self.type = .Salary(UInt(Double(pay) + byAmount))
        }
    }
    
    public func raise (byPercent : Double){
        switch self.type {
        case .Hourly(let pay):
            self.type = .Hourly(pay + (byPercent * pay))
        case .Salary(let pay):
            self.type = .Salary(UInt(Double(pay) + (byPercent * Double(pay))))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    public var firstName = ""
    public var lastName = ""
    public var age = 0
    // Consulted Ai to help me figure out the age restriction
    private var _job: Job? = nil // // actual storage, nobody outside can touch this
    public var job: Job? {
        get { return _job }
        set {
            if age >= 18 {
                _job = newValue
            }
        }
    }

    private var _spouse: Person? = nil
    public var spouse: Person? {
        get { return _spouse }
        set {
            if age >= 18 {
                _spouse = newValue
            }
        }
    }
    public init(firstName : String, lastName : String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    public func toString() -> String {
        var jobString = "nil"
        if let j = job {
            switch j.type {
            case .Hourly(let pay):
                jobString = "Hourly(\(pay))"
            case .Salary(let pay):
                jobString = "Salary(\(pay))"
            }
        }
        
        var spouseString = "nil"
        if let s = spouse {
            spouseString = s.firstName
        }
        
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobString) spouse:\(spouseString)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    public var members: [Person] = []
    public init(spouse1: Person, spouse2: Person){
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
    
    
    public func haveChild(_ child: Person) -> Bool{
        
        if members[0].age < 21 && members[1].age < 21{
            return false
        }
        
        members.append(child)
        return true
    }
    
    public func householdIncome() -> Int{
        var sum = 0
        
        for member in members{
            if let job = member.job {
                sum +=  job.calculateIncome(2000)
            }
        }
        return sum
     
        
    }
}
