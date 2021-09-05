import UIKit
import Firebase

class ViewController: UIViewController {
    var db: Firestore!
    var phoneArray: [NewList] = []
    var alert = UIAlertController()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        db = Firestore.firestore()
        super.viewDidLoad()
        MyAnalytics.shared.trackEvent(name: "view_vc")
        view.backgroundColor = .white
        self.title = "Список"
        let newBackButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(popUpdatedTariffs))
        self.navigationItem.rightBarButtonItem = newBackButton
        setTableView()
        loadDaata()
        ceckForDataUpdate()
    }
    
    @objc func popUpdatedTariffs() {
        alert = UIAlertController(title: "Добавить новую запись?", message: "", preferredStyle: .alert)
        alert.addTextField {(textFild: UITextField) in
            textFild.placeholder = "Введите имя"}
        
        alert.addTextField {(textFild: UITextField) in
            textFild.placeholder = "Введите номер"}
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { (action: UIAlertAction) in self.saveData()}
        ))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        if let name = alert.textFields?.first?.text,
           let phone = alert.textFields?.last?.text {
            let newMyList = NewList(name: name, phone: phone, timeStamp: Date().timeIntervalSince1970)
            FirestoreDB.shared.setData(newList: newMyList)
        }
        
    }
    
    func ceckForDataUpdate() {
        FirestoreDB.shared.getData(completion: {doc in
            guard let dict = doc else {return}
            self.phoneArray.append(dict)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func loadDaata() {
        FirestoreDB.shared.loadData(completion: {doc in
            guard let dict = doc else {return}
            self.phoneArray = dict
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        phoneArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath as IndexPath) as UITableViewCell
        cell.textLabel?.text = "\(phoneArray[indexPath.row].name) : \(phoneArray[indexPath.row].phone)"
        return cell
    }
}
