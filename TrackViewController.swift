import UIKit

class TrackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    final let urlString = "Your url"

    
    @IBOutlet weak var tableView: UITableView!
    
    var dateArray = [String]()
    var nameArray = [String]()
    var deptArray = [String]()
    var phoneArray = [String]()
    var itemIdArray = [String]()
    var itemTypeArray = [String]()
    var itemNotesArray = [String]()
    var statusArray = [String]()
    var imgURLArray = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.downloadJsonWithURL()

    }
    
    func downloadJsonWithURL() {
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: { (data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
                print(jsonObj!)
                
                if let transactionArray = jsonObj! as? NSArray{
                    for transaction in transactionArray {
                        if let transactionDict = transaction as? NSDictionary {
                            if let date = transactionDict.value(forKey: "DTStamp") {
                                self.dateArray.append(date as! String)
                            }
                            if let name = transactionDict.value(forKey: "userName") {
                                self.nameArray.append(name as! String)
                            }
                            if let name = transactionDict.value(forKey: "userDept") {
                                self.deptArray.append(name as! String)
                            }
                            if let name = transactionDict.value(forKey: "userPhone") {
                                self.phoneArray.append(name as! String)
                            }
                            if let name = transactionDict.value(forKey: "itemID") {
                                self.itemIdArray.append(name as! String)
                            }
                            if let name = transactionDict.value(forKey: "itemType") {
                                self.itemTypeArray.append(name as! String)
                            }
                            if let name = transactionDict.value(forKey: "itemNotes") {
                                self.itemNotesArray.append(name as! String)
                            }
                            if let name = transactionDict.value(forKey: "chkInout") {
                                self.statusArray.append(name as! String)
                            }
//                            if let image = transactionDict.value(forKey: "signImgFilename") {
//                                self.imgURLArray.append(image as! String)
//                            }
                            
                           
                        }
                    }
                }
                OperationQueue.main.addOperation({
                    //reload table
                    self.tableView.reloadData()
                })
            }
            
        }).resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.dateLabel.text = dateArray[indexPath.row]
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.deptLabel.text = deptArray[indexPath.row]
        cell.phoneLabel.text = phoneArray[indexPath.row]
        cell.itemIdLabel.text = itemIdArray[indexPath.row]
        cell.itemTypeLabel.text = itemTypeArray[indexPath.row]
        cell.itemNotesLabel.text = itemNotesArray[indexPath.row]
        cell.statusLabel.text = statusArray[indexPath.row]
        
        //get image data
//        let imgURL = NSURL(string: imgURLArray[indexPath.row])
//
//        if imgURL != nil {
//            let data = NSData(contentsOf: (imgURL as URL?)!)
//            cell.imgView.image = UIImage(data: data! as Data)
//        }

        return cell
    }
    
    
    func downloadJsonWithTask() {
        let url = NSURL(string: urlString)
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: { (data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
                
                print(jsonObj!)
            }
            
            
        }).resume()
        
    }
    

}


