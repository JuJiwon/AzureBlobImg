
import UIKit
import AZSClient

class ViewController: UIViewController {
    
    let connStr = "DefaultEndpointsProtocol=https;AccountName=codingstr2;AccountKey=NQKaG+dQJEYXF1Guwd4q7gHRvZPuzEJzzDoEXO9XY5CyWcaotcR14xNuKQLC0IwLqnpKkYlsQKwLfq/ghtN8OQ==;EndpointSuffix=core.windows.net"
    
    var containerA: AZSCloudBlobContainer!
    var clientA: AZSCloudBlobClient!
    
    @IBOutlet var btnA: UIButton!
    @IBOutlet var btnB: UIButton!
    @IBOutlet var btnC: UIButton!
    var imgV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bound = self.view.bounds
        imgV = UIImageView(frame: CGRect(x: bound.width/2-125, y: bound.height/2-100, width: 250, height: 200))
        self.view.addSubview(self.imgV)
        
        // 컨테이너 추가
        let stAccount: AZSCloudStorageAccount = try! AZSCloudStorageAccount(fromConnectionString: self.connStr)
        clientA = stAccount.getBlobClient()
        
        containerA = clientA.containerReference(fromName: "codingstr")
        containerA.createContainerIfNotExists { (errA, isOK) in
            if errA != nil {
                print("Error in creating container.")
            }
        }
        
    }
    
    @IBAction func btnPressedA() {
        
        // Blob 추가
        let blobA: AZSCloudBlockBlob = containerA.blockBlobReference(fromName: "1.jpg")
        let urlA = Bundle.main.url(forResource: "a", withExtension: "jpg")
        let dataA: Data = try! Data(contentsOf: urlA!)
        blobA.upload(from: dataA as Data) { (errA) in
            if errA != nil {
                print("err up")
                print(errA!)
            } else {
                print("suc up")
            }
        }
        
    }
    
    @IBAction func btnPressedB() {
        
        // Blob 삭제
        let blobA: AZSCloudBlockBlob = containerA.blockBlobReference(fromName: "1.jpg")
        blobA.delete(with: AZSDeleteSnapshotsOption.none) { (errA) in
            if errA != nil {
                print("err del")
                print(errA!)
            } else {
                print("suc del")
            }
        }
        
    }
    
    @IBAction func btnPressedC() {
        
        // Blob 다운
        let blobA: AZSCloudBlockBlob = containerA.blockBlobReference(fromName: "1.jpg")
        blobA.downloadToData { (errA, dataA) in
            if errA != nil {
                print("err down")
                print(errA!)
            } else {
                print("suc down")
                DispatchQueue.main.async {
                    self.imgV.image = UIImage(data: dataA!)
                }
            }
        }
    }
    
}


/*
 https://docs.microsoft.com/ko-kr/azure/storage/blobs/storage-ios-how-to-use-blob-storage 참조
 
 블록 Blob: 이미지 파일 등
 추가 Blob: 텍스트 파일 등
 */
