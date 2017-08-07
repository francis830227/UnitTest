//
//  ProfileViewController.swift
//  Patissier
//
//  Created by Francis Tseng on 2017/7/6.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import UILoadControl
import CoreData
import FBSDKLoginKit

class ProfileViewController: UIViewController, ProfileManagerDelegate, MyProfileManagerDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteOutlet: UIButton!
    @IBOutlet weak var purchasedOutlet: UIButton!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var favoriteCollectionView: UICollectionView!

    @IBAction func favoritePressed(_ sender: UIButton) {
        favoriteCollectionView.isHidden = false
        favoriteOutlet.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        favoriteOutlet.layer.cornerRadius = 4
        purchasedOutlet.layer.backgroundColor = UIColor.clear.cgColor
        profileTableView.isHidden = true
    }

    @IBAction func purchasedPressed(_ sender: UIButton) {
        profileTableView.isHidden = false
        purchasedOutlet.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        purchasedOutlet.layer.cornerRadius = 4
        favoriteOutlet.layer.backgroundColor = UIColor.clear.cgColor
        favoriteCollectionView.isHidden = true

    }

    @IBAction func exitPressed(_ sender: Any) {
        FBSDKLoginManager().logOut()
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "jwt")

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeController =  mainStoryboard.instantiateViewController(withIdentifier: "loginview") as? LoginController
        appDelegate?.window?.rootViewController = homeController

    }

    let profileManager = ProfileManager()

    let myProfileManager = MyProfileManager()

    var profiles = [Profile]()

    var myProfiles = [MyProfile]()

    var favorite: FavoriteMO!

    var favorites = [FavoriteMO]()

    var coreDataID = ""

    //swiftlint:disable force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //swiftlint:enable force_cast

    override func viewDidLoad() {
        super.viewDidLoad()

        //gradient navigationBar
        var colors = [UIColor]()
        colors.append(UIColor(red: 3/255, green: 63/255, blue: 122/255, alpha: 1))
        colors.append(UIColor(red: 4/255, green: 107/255, blue: 149/255, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Georgia-Bold", size: 18)!]
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(red: 53/255.0, green: 184/255.0, blue: 208/255.0, alpha: 0.85).cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 1
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2

        favoriteCollectionView.isHidden = true

        profileManager.delegate = self
        self.profileManager.requestProfiles()

        myProfileManager.delegate = self
        self.myProfileManager.requestMyProfiles()

        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 25
        flowLayout.minimumInteritemSpacing = 25
        flowLayout.sectionInset = UIEdgeInsets.init(top: 24, left: 20, bottom: 10, right: 20)
        favoriteCollectionView.collectionViewLayout = flowLayout

        purchasedOutlet.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor

        profileTableView.loadControl = UILoadControl(target: self, action: #selector(loadMore(sender:)))
        profileTableView.loadControl?.heightLimit = 60.0

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<FavoriteMO> = FavoriteMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            do {
                favorites = try context.fetch(request)
            } catch {
                print(error)
            }
            favoriteCollectionView.reloadData()
        }
    }

    func manager(_ manager: ProfileManager, didGet profiles: [Profile]) {
        self.profiles = profiles
        print(profiles)
        DispatchQueue.main.async {
            self.profileTableView.reloadData()
        }
    }

    func manager(_ manager: ProfileManager, didFailWith error: Error) {
        print(error)
    }

    func manager(_ manager: MyProfileManager, didGet myProfiles: [MyProfile]) {
        self.myProfiles = myProfiles
        self.userImageView.downloadedFrom(link: "http://52.198.40.72/patissier/users/\(self.myProfiles[0].myID)/picture.jpg", contentMode: .scaleAspectFill)
    }

    func manager(_ manager: MyProfileManager, didFailWith error: Error) {
        print(error)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableViewCell", for: indexPath) as? ProfileTableViewCell
        cell?.purchasedDate.text = profiles[indexPath.item].createdTime
        cell?.purchasedPrice.text = "Total: $\(profiles[indexPath.item].totalAmount)"
        for item in profiles[indexPath.item].items {
            cell?.purchasedImageView.downloadedFrom(link: "http://52.198.40.72/patissier/products/\(item.itemID)/preview.jpg", contentMode: .scaleAspectFill)
        }

        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritecollectionview", for: indexPath) as? FavoriteCollectionViewCell
        //Font
        cell?.favoriteName.font = UIFont.asiTextStyle5Font()
        cell?.favoritePrice.font = UIFont.asiTextStyle6Font()

        //Image
        if let imageData = favorites[indexPath.row].image {
            if let cellImage = UIImage(data: imageData as Data) {
                cell?.favoriteImageView.image = cellImage
            }
        }

        //like style
        cell?.favoriteLike.tag = indexPath.row

        cell?.favoriteLike.tintColor = UIColor(red: 255/255.0, green: 53/255.0, blue: 71/255.0, alpha: 1)
        cell?.favoriteLike.layer.borderColor = UIColor(red: 255/255.0, green: 53/255.0, blue: 71/255.0, alpha: 1).cgColor

        cell?.favoriteLike.tintColor = UIColor(red: 255/255.0, green: 53/255.0, blue: 71/255.0, alpha: 1)
        cell?.favoriteLike.layer.borderColor = UIColor(red: 255/255.0, green: 53/255.0, blue: 71/255.0, alpha: 1).cgColor

        cell?.favoriteLike.clipsToBounds = true
        cell?.favoriteLike.layer.masksToBounds = true
        cell?.favoriteLike.layer.cornerRadius = 4
        cell?.favoriteLike.layer.borderWidth = 0.2

        cell?.favoriteLike.addTarget(self, action: #selector(deleteCoreData), for: .touchUpInside)
        cell?.favoriteName.text = favorites[indexPath.item].name
        cell?.favoritePrice.text = "$ \(favorites[indexPath.item].price)"

        return cell!
    }

    func deleteCoreData(sender: UIButton) {

        //delete
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            context.delete(favorites[sender.tag])

            appDelegate.saveContext()
            let request: NSFetchRequest<FavoriteMO> = FavoriteMO.fetchRequest()
            do {
                favorites = try context.fetch(request)
            } catch {
                print(error)
            }
            favoriteCollectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 154, height: 160)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            scrollView.loadControl?.update()
        }
    }

    func loadMore(sender: AnyObject?) {
        DispatchQueue.main.asyncAfter(deadline: (.now() + 3.0)) {
            self.profileManager.requestProfiles()
            self.profileTableView.loadControl?.endLoading()
            self.profileTableView.reloadData()

        }
    }
}
