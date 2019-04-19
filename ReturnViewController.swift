import UIKit
import AVFoundation

class ReturnViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,AVCaptureMetadataOutputObjectsDelegate {


    
    @IBOutlet weak var staffDropDown: UIPickerView!
    @IBOutlet weak var staffTextBox: UITextField!
    
    var list = ["Laurette Foster","Timothy Cole","Qing Yan","Natalie Williamson"]
    
    //Faculty text fields
    @IBOutlet weak var facIdText: UITextField!
    @IBOutlet weak var facNameText: UITextField!
    @IBOutlet weak var facDeptText: UITextField!
    @IBOutlet weak var facPhoneText: UITextField!
    @IBOutlet weak var facEmailText: UITextField!
    
    //Equipment text fields
    @IBOutlet weak var equipmentIdText: UITextField!
    @IBOutlet weak var equipmentTypeText: UITextField!
    @IBOutlet weak var equipmentNotesText: UITextField!
    
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    var captureSession2 = AVCaptureSession()
    
    @IBAction func facultyScan(_ sender: UIButton) {
        //get the back-facing camera for capturing videos
        connectDevice1()
    }
    
    @IBAction func equipmentScan(_ sender: UIButton) {
        connectDevice2()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status field text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                let item = metadataObj.stringValue
                print(item!)
                
                let items = item?.components(separatedBy: "\n")
                print(items!)
                if (items?.count)! > 3 {
                    print(items?.count as Any)
                    print(items![1])
                    
                    let facInfoId       = items![0]
                    let facInfoName     = items![1]
                    let facInfoDept     = items![2]
                    let facInfoPhone    = items![3]
                    let facInfoEmail    = items![4]
                    
                    //populate faculty form field
                    self.facIdText.text         = facInfoId
                    self.facNameText.text       = facInfoName
                    self.facDeptText.text       = facInfoDept
                    self.facPhoneText.text      = facInfoPhone
                    self.facEmailText.text      = facInfoEmail
                    
                    stopSession()
                }
                else {
                    let equipmentId         = items![0]
                    let equipmentType       = items![1]
                    let equipmentNotes      = items![2]
                    
                    //populate equipment form field
                    self.equipmentIdText.text         = equipmentId
                    self.equipmentTypeText.text       = equipmentType
                    self.equipmentNotesText.text      = equipmentNotes
                    
                    stopSession2()
                }
                
                
            }
        }
        
    }
    
    func stopSession() {
        //stop capture session
        videoPreviewLayer?.isHidden = true
        qrCodeFrameView?.isHidden = true
        captureSession.stopRunning()
        
    }
    
    func stopSession2() {
        //stop capture session
        videoPreviewLayer?.isHidden = true
        qrCodeFrameView?.isHidden = true
        captureSession2.stopRunning()
        
    }
    
    func connectDevice1() {
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Faied to get the camera device")
            return
        }
        
        do {
            //get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            //Set the input device on the capture session
            captureSession.addInput(input)
            
            //initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            
            
        } catch {
            //if any error occurs, simply print it out and dont continue anymore
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        //Start video capture
        captureSession.startRunning()
        
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
    }
    
    func connectDevice2() {
        
        let deviceDiscoverySession2 = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession2.devices.first else {
            print("Faied to get the camera device")
            return
        }
        
        do {
            //get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            //Set the input device on the capture session
            captureSession2.addInput(input)
            
            //initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession2.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            
            
        } catch {
            //if any error occurs, simply print it out and dont continue anymore
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession2)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        //Start video capture
        captureSession2.startRunning()
        
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
    }
    

    //When check out button pressed, call the php script and save the data to database
    @IBAction func Return(_ sender: UIButton) {
        
        //creating parameters for the post request
        let request = NSMutableURLRequest(url: NSURL(string: "your url")! as URL)
        request.httpMethod = "POST"
        
        let postString = "facID=\(self.facIdText.text!)&facName=\(self.facNameText.text!)&facDept=\(self.facDeptText.text!)&facPhone=\(self.facPhoneText.text!)&facEmail=\(self.facEmailText.text!)&equipmentId=\(self.equipmentIdText.text!)&equipmentType=\(self.equipmentTypeText.text!)&equipmentNotes=\(self.equipmentNotesText.text!)&cteStaff=\(self.staffTextBox.text!)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            else {
                print("response=\(String(describing: response))")
                
                
                //create an alert
                let alert = UIAlertController(title: "Succesful", message: "Equipment Returned", preferredStyle: .alert)
                
                let restartAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                    
                    let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.navigationController?.pushViewController(ViewController, animated: true)
                    self.dismiss(animated: false, completion: nil)
                    
                }
                
                alert.addAction(restartAction)
                self.present(alert, animated: true, completion: nil)
                
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(String(describing: responseString))")
            }
            
        }
        task.resume()
        
    }
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return list.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.staffTextBox.text = self.list[row]
        self.staffDropDown.isHidden = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.staffTextBox {
            self.staffDropDown.isHidden = false
        }
    }
    


}
