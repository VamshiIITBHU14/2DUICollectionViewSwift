//
//  ViewController.swift
//  2DUICollectionView
//
//  Created by Vamshi Krishna on 13/04/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var scrollXpos: CGFloat = 0.0
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var cellView: UIView?
    var bookName: UILabel?
    var genreName: UILabel?
    var dummyLabel: UILabel?
    var authorName: UILabel?
    var cellImage: UIImageView?
    var button: UIButton?
    var dummyView: UIView?
    
    var items = [Any]()
    var itemIds = [Any]()
    var itemBookLabels = [Any]()
    var itemAuthorLabels = [Any]()
    var itemGenreLabels = [Any]()
    var itemImages = [Any]()
    
    var sectionHeaderTitles = [Any]()
    var sectionValueBookTitles = [Any]()
    var sectionValueAuthorTitles = [Any]()
    var sectionValueCoverImages = [Any]()
    var sectionValueBookIds = [Any]()
    var sectionValueAuthorIds = [Any]()
    var sectionValueAboutBooks = [Any]()
    var sectionValueGenreTitles = [Any]()
    var parsedData = [String:Any]()
    var dummyDic = [AnyHashable:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.alwaysBounceVertical = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: "background_white")?.draw(in: view.bounds)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor(patternImage: image!)
        navigationController?.navigationBar.barTintColor = UIColor.purple
    
        let path = Bundle.main.path(forResource: "DataSource", ofType: "json")
        let data = NSData(contentsOfFile: path!)

        do {
            parsedData = try JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:Any]
            print(parsedData)
            setUpViews()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func setUpViews(){
        sectionHeaderTitles = [Any]()
        
        for (key, _) in parsedData {
           sectionHeaderTitles.append(key)
        }
    
        sectionValueBookTitles = [Any]()
        sectionValueAuthorTitles = [Any]()
        sectionValueBookIds = [Any]()
        sectionValueAuthorIds = [Any]()
        sectionValueAboutBooks = [Any]()
        sectionValueCoverImages = [Any]()
        sectionValueGenreTitles = [Any]()
        
        for (jsonstring,_) in parsedData {
            var bookTitles = [Any]()
            var authorTitles = [Any]()
            var bookIds = [Any]()
            var authorIds = [Any]()
            var aboutBooks = [Any]()
            var coverImages = [Any]()
            let genreTitles = [Any]()
            
            var jsonarray : [Any] = parsedData[jsonstring] as! [Any]
            for i in 0..<jsonarray.count {
                var userJson: [AnyHashable: Any]? = (jsonarray[i] as? [AnyHashable: Any])
                let bookTitle: String? = (userJson?["title"] as? String)
                let authorTitle: String? = (userJson?["author_name"] as? String)
                let bookId: Any? = userJson?["season_id"]
                let authorId: Any? = userJson?["author_id"]
                let aboutBook: String? = (userJson?["about"] as? String)
                let coverImage: String? = (userJson?["cover_image"] as? String)
                bookTitles.append(bookTitle!)
                authorTitles.append(authorTitle!)
                bookIds.append(bookId!)
                authorIds.append(authorId!)
                aboutBooks.append(aboutBook!)
                coverImages.append(coverImage!)
            }
            sectionValueBookTitles.append(bookTitles)
            sectionValueAuthorTitles.append(authorTitles)
            sectionValueBookIds.append(bookIds)
            sectionValueAuthorIds.append(authorIds)
            sectionValueAboutBooks.append(aboutBooks)
            sectionValueCoverImages.append(coverImages)
            sectionValueGenreTitles.append(genreTitles)
        }
        myCollectionView .reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionHeaderTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BookStoreCollectionViewCell? = (collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? BookStoreCollectionViewCell)
        for viewObject: UIView in (cell?.contentView.subviews)! {
            if (viewObject is UILabel) {
                viewObject.removeFromSuperview()
            }
        }
        dummyLabel = UILabel(frame: CGRect(x: CGFloat(0.15*CGFloat(view.frame.size.width)), y: CGFloat(0), width: CGFloat(view.frame.size.width), height: CGFloat(30)))
        dummyLabel?.text = sectionHeaderTitles[indexPath.section] as? String
        dummyLabel?.textAlignment = .left
        dummyLabel?.textColor = UIColor(red: CGFloat(99.0 / 255.0), green: CGFloat(89.0 / 255.0), blue: CGFloat(141.0 / 255.0), alpha: CGFloat(1))
        dummyLabel?.numberOfLines = 0
        dummyLabel?.font = UIFont(name: "ProximaNova-Bold", size: CGFloat(16))
        dummyLabel?.adjustsFontSizeToFitWidth = true
        cell?.contentView.addSubview(dummyLabel!)
        
        cell?.collectionScroll.contentSize = CGSize(width: CGFloat(((sectionValueCoverImages[indexPath.section] as AnyObject).count * 100) + 170), height: CGFloat((cell?.frame.size.height)!))
        for viewObject: UIView in (cell?.collectionScroll.subviews)! {
                viewObject.removeFromSuperview()
        }
        scrollXpos = 0.15*CGFloat(view.frame.size.width)
        for i in 0..<(sectionValueBookTitles[indexPath.section] as AnyObject).count {
            cellView = UIView(frame: CGRect(x: CGFloat(scrollXpos), y: CGFloat(0), width: CGFloat(120), height: CGFloat(180)))
            scrollXpos += 110
            cell?.collectionScroll.addSubview(cellView!)
            dummyView = UIImageView(frame: CGRect(x: CGFloat(5), y: CGFloat(30), width: CGFloat(100), height: CGFloat(140)))
            dummyView?.layer.borderColor = UIColor(red: CGFloat(99.0 / 255.0), green: CGFloat(89.0 / 255.0), blue: CGFloat(141.0 / 255.0), alpha: CGFloat(1)).cgColor
            dummyView?.layer.borderWidth = 1.0
            dummyView?.layer.cornerRadius = 6
            dummyView?.clipsToBounds = true
          
            button = UIButton(type: .custom)
            button?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            button?.tag = ((sectionValueBookIds[indexPath.section] as! [Any])[i] as! Int)
            button?.setTitle("", for: .normal)
            button?.frame = CGRect(x: CGFloat(5), y: CGFloat(30), width: CGFloat(100), height: CGFloat(140))
            cellImage = UIImageView(frame: CGRect(x: CGFloat(5), y: CGFloat(30), width: CGFloat(100), height: CGFloat(90)))
           // cellImage.sd_setImage(with: URL(string: sectionValueCoverImages[indexPath.section][i]), placeholderImage: UIImage(named: "placeholder.png"))
            //Intentionally put a static image here. You can use the image url coming via json object
            cellImage?.image = UIImage(named:"book")
            cellImage?.layer.cornerRadius = 6
            cellImage?.clipsToBounds = true

            authorName = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((cellImage?.frame.maxY)!), width: CGFloat(90), height: CGFloat(20)))
            
            authorName?.text = " "+("\((sectionValueAuthorTitles[indexPath.section] as! [Any] )[i])")
            authorName?.textColor = UIColor(red: CGFloat(99.0 / 255.0), green: CGFloat(89.0 / 255.0), blue: CGFloat(141.0 / 255.0), alpha: CGFloat(1))
            authorName?.numberOfLines = 0
            authorName?.font = UIFont(name: "ProximaNova-Bold", size: CGFloat(14))
            authorName?.adjustsFontSizeToFitWidth = true
            
            bookName = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((cellImage?.frame.maxY)! + 15), width: CGFloat(90), height: CGFloat(20)))
            bookName?.text = " "+("\((sectionValueBookTitles[indexPath.section] as! [Any] )[i])")
            bookName?.textColor = UIColor(red: CGFloat(99.0 / 255.0), green: CGFloat(89.0 / 255.0), blue: CGFloat(141.0 / 255.0), alpha: CGFloat(1))
            bookName?.numberOfLines = 0
            bookName?.font = UIFont(name: "ProximaNovaA-Regular", size: CGFloat(14))
            bookName?.adjustsFontSizeToFitWidth = true
            
            genreName = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat((cellImage?.frame.maxY)! + 30), width: CGFloat(90), height: CGFloat(20)))
            genreName?.text = " "+("\((sectionValueBookTitles[indexPath.section] as! [Any] )[i])")
            genreName?.textColor = UIColor(red: CGFloat(99.0 / 255.0), green: CGFloat(89.0 / 255.0), blue: CGFloat(141.0 / 255.0), alpha: CGFloat(1))
            genreName?.numberOfLines = 0
            genreName?.font = UIFont(name: "ProximaNovaA-Regular", size: CGFloat(14))
            genreName?.adjustsFontSizeToFitWidth = true
            
            cellView?.addSubview(button!)
            cellView?.addSubview(cellImage!)
            cellView?.addSubview(authorName!)
            cellView?.addSubview(bookName!)
            cellView?.addSubview(genreName!)
            cellView?.addSubview(dummyView!)
        }
        return cell!
    }
    
    func buttonAction(sender: UIButton!) {
        print("Button tapped \(sender.tag)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let retval = CGSize(width: CGFloat(view.frame.size.width - 10), height: CGFloat(180))
        return retval
    }
}



