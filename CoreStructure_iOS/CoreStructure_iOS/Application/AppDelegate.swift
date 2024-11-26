//
//  AppDelegate.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/8/24.
//

import UIKit
import UserNotifications //import UserNotifications 1 local

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setLanguage(langCode: "en") // default language en
        
        
        let app = AppConfiguration()
        print("apiBaseURL",
              app.apiBaseURL,
              "\n",
              "apiKey",
              app.apiKey,
              "\n",
              "bundleID",
              app.bundleID)
        
    
//        // Handle any incoming URL when the app is launched
//           if let url = launchOptions?[.url] as? URL {
//               handleIncomingURL(url)
//           }

//        setupTitleNavigationBar()
        configureNotification()  // push notification 2 local
        print("didFinishLaunchingWithOptions") //AIzaSyBApx6bA_YNHU8zL_XBrpSI10wol9EBVsA
        return true
    }
    
  

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("configurationForConnecting")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("didDiscardSceneSessions")
    }
    
}


// MARK: - HAndle Deep Line
extension AppDelegate{
    
   
    private func handleIncomingURL(_ url: URL) {
        // Parse the URL and navigate accordingly
        let urlString = url.absoluteString
        print("Received URL: \(urlString)")

        // Example: Handle a specific path
        if urlString.contains("some/path") {
            // Navigate to the specific view controller
            // You can use a NotificationCenter or a delegate to inform your view controller
        }
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        // Handle the notification and perform necessary actions
//        completionHandler()
//    }
    
    
    
}



//MARK: Handle navigation contoller
extension AppDelegate{
    
   private func setupTitleNavigationBar(font: UIFont? = UIFont.systemFont(ofSize: 17, weight: .regular),
                                 titleColor: UIColor = .white){
        
        let titleAttribute = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: titleColor
        ]
       
       let appearance = UINavigationBarAppearance()
       appearance.configureWithOpaqueBackground()
       appearance.shadowColor = .mainBlueColor
 
       appearance.backgroundColor = .mainBlueColor
       appearance.titleTextAttributes = titleAttribute as [NSAttributedString.Key : Any]
        
        
       UINavigationBar.appearance().standardAppearance = appearance
       UINavigationBar.appearance().scrollEdgeAppearance = appearance
       UINavigationBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().backItem?.title = ""

 
    }
}




//firebase //https://github.com/firebase/firebase-ios-sdk


//MARK: Setup Push Notification Local
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
    
    
    private func configureNotification(){
        // Request user authorization for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            granted ? print("User granted authorization") :  print("User denied authorization")
        }
        // Set the delegate for UNUserNotificationCenter
        UNUserNotificationCenter.current().delegate = self
    }
    
    
    // Handle the display of notifications while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Customize the presentation options as needed
        completionHandler([.alert, .sound])
    }
    
    // Handle the user's response to the notification (e.g., tapping on it) tapped on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the response as needed
        // Handle the notification response here
        let userInfo = response.notification.request.content.userInfo
        
        print("userInfo: \(userInfo)")
        


        

        // Get the current view controller
        guard let window = SceneDelegate().window /*UIApplication.shared.keyWindow*/,
              let rootViewController = window.rootViewController else {
            completionHandler()
            return
        }
        
//         Create an instance of the target view controller
        let targetViewController = UIViewController()
        targetViewController.view.backgroundColor = .orange
        
        // Push the target view controller onto the navigation stack
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.pushViewController(targetViewController, animated: false)
        } else {
            let navigationController = UINavigationController(rootViewController: targetViewController)
            window.rootViewController = navigationController
        }
        
        // Call the completion handler when you're done processing the notification
        completionHandler()
        
    }
}



import UIKit

public protocol KDDragAndDropCollectionViewDataSource : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath?
    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject

    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to : IndexPath) -> Void
    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem : AnyObject, atIndexPath indexPath: IndexPath) -> Void
    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath: IndexPath) -> Void
    
    func collectionView(_ collectionView: UICollectionView, cellIsDraggableAtIndexPath indexPath: IndexPath) -> Bool
    func collectionView(_ collectionView: UICollectionView, cellIsDroppableAtIndexPath indexPath: IndexPath) -> Bool
    
    func collectionView(_ collectionView: UICollectionView, stylingRepresentationView: UIView) -> UIView?
}

extension KDDragAndDropCollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, stylingRepresentationView: UIView) -> UIView? {
        return nil
    }
    func collectionView(_ collectionView: UICollectionView, cellIsDraggableAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, cellIsDroppableAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
}

open class KDDragAndDropCollectionView: UICollectionView, KDDraggable, KDDroppable {
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var draggingPathOfCellBeingDragged : IndexPath?
    
    var iDataSource : UICollectionViewDataSource?
    var iDelegate : UICollectionViewDelegate?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    
    // MARK : KDDraggable
    public func canDragAtPoint(_ point : CGPoint) -> Bool {
        if let dataSource = self.dataSource as? KDDragAndDropCollectionViewDataSource,
            let indexPathOfPoint = self.indexPathForItem(at: point) {
            return dataSource.collectionView(self, cellIsDraggableAtIndexPath: indexPathOfPoint)
        }
        
        return false
    }
    
    public func representationImageAtPoint(_ point : CGPoint) -> UIView? {
        
        guard let indexPath = self.indexPathForItem(at: point) else {
            return nil
        }
        
        guard let cell = self.cellForItem(at: indexPath) else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.isOpaque, 0)
        cell.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: image)
        imageView.frame = cell.frame
        
        return imageView
    }
    
    public func stylingRepresentationView(_ view: UIView) -> UIView? {
        guard let dataSource = self.dataSource as? KDDragAndDropCollectionViewDataSource else {
            return nil
        }
        return dataSource.collectionView(self, stylingRepresentationView: view)
    }
    
    public func dataItemAtPoint(_ point : CGPoint) -> AnyObject? {
        
        guard let indexPath = self.indexPathForItem(at: point) else {
            return nil
        }
        
        guard let dragDropDS = self.dataSource as? KDDragAndDropCollectionViewDataSource else {
            return nil
        }
        
        return dragDropDS.collectionView(self, dataItemForIndexPath: indexPath)
    }
    
    
    
    public func startDraggingAtPoint(_ point : CGPoint) -> Void {
        
        self.draggingPathOfCellBeingDragged = self.indexPathForItem(at: point)
        
        self.reloadData()
        
    }
    
    public func stopDragging() -> Void {
        
        if let idx = self.draggingPathOfCellBeingDragged {
            if let cell = self.cellForItem(at: idx) {
                cell.isHidden = false
            }
        }
        
        self.draggingPathOfCellBeingDragged = nil
        
        self.reloadData()
        
    }
    
    public func dragDataItem(_ item : AnyObject) -> Void {
        
        guard let dragDropDataSource = self.dataSource as? KDDragAndDropCollectionViewDataSource else {
            return
        }
        
        guard let existngIndexPath = dragDropDataSource.collectionView(self, indexPathForDataItem: item) else {
            return
            
        }
        
        dragDropDataSource.collectionView(self, deleteDataItemAtIndexPath: existngIndexPath)
        
        if self.animating {
            self.deleteItems(at: [existngIndexPath])
        }
        else {
            
            self.animating = true
            self.performBatchUpdates({ () -> Void in
                self.deleteItems(at: [existngIndexPath])
            }, completion: { complete -> Void in
                self.animating = false
                self.reloadData()
            })
        }
        
    }
    
    // MARK : KDDroppable
    
    public func canDropAtRect(_ rect : CGRect) -> Bool {
        
        return (self.indexPathForCellOverlappingRect(rect) != nil)
    }
    
    public func indexPathForCellOverlappingRect( _ rect : CGRect) -> IndexPath? {
        
        var overlappingArea : CGFloat = 0.0
        var cellCandidate : UICollectionViewCell?
        let dataSource = self.dataSource as? KDDragAndDropCollectionViewDataSource
        
        
        let visibleCells = self.visibleCells
        if visibleCells.count == 0 {
            return IndexPath(row: 0, section: 0)
        }
        
        if  isHorizontal && rect.origin.x > self.contentSize.width ||
            !isHorizontal && rect.origin.y > self.contentSize.height {
            
            if dataSource?.collectionView(self, cellIsDroppableAtIndexPath: IndexPath(row: visibleCells.count - 1, section: 0)) == true {
                return IndexPath(row: visibleCells.count - 1, section: 0)
            }
            return nil
        }
        
        
        for visible in visibleCells {
            
            let intersection = visible.frame.intersection(rect)
            
            if (intersection.width * intersection.height) > overlappingArea {
                
                overlappingArea = intersection.width * intersection.height
                
                cellCandidate = visible
            }
            
        }
        
        if let cellRetrieved = cellCandidate, let indexPath = self.indexPath(for: cellRetrieved), dataSource?.collectionView(self, cellIsDroppableAtIndexPath: indexPath) == true {
            
            return self.indexPath(for: cellRetrieved)
        }
        
        return nil
    }
    
    
    fileprivate var currentInRect : CGRect?
    public func willMoveItem(_ item : AnyObject, inRect rect : CGRect) -> Void {
        
        let dragDropDataSource = self.dataSource as! KDDragAndDropCollectionViewDataSource // its guaranteed to have a data source
        
        if let _ = dragDropDataSource.collectionView(self, indexPathForDataItem: item) { // if data item exists
            return
        }
        
        if let indexPath = self.indexPathForCellOverlappingRect(rect) {
            
            dragDropDataSource.collectionView(self, insertDataItem: item, atIndexPath: indexPath)
            
            self.draggingPathOfCellBeingDragged = indexPath
            
            self.animating = true
            
            self.performBatchUpdates({ () -> Void in
                
                self.insertItems(at: [indexPath])
                
            }, completion: { complete -> Void in
                
                self.animating = false
                
                // if in the meantime we have let go
                if self.draggingPathOfCellBeingDragged == nil {
                    
                    self.reloadData()
                }
                
                
            })
            
        }
        
        currentInRect = rect
        
    }
    
    public var isHorizontal : Bool {
        return (self.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .horizontal
    }
    
    public var animating: Bool = false
    
    public var paging : Bool = false
    func checkForEdgesAndScroll(_ rect : CGRect) -> Void {
        
        if paging == true {
            return
        }
        
        let currentRect : CGRect = CGRect(x: self.contentOffset.x, y: self.contentOffset.y, width: self.bounds.size.width, height: self.bounds.size.height)
        var rectForNextScroll : CGRect = currentRect
        
        if isHorizontal {
            
            let leftBoundary = CGRect(x: -30.0, y: 0.0, width: 30.0, height: self.frame.size.height)
            let rightBoundary = CGRect(x: self.frame.size.width, y: 0.0, width: 30.0, height: self.frame.size.height)
            
            if rect.intersects(leftBoundary) == true {
                rectForNextScroll.origin.x -= self.bounds.size.width * 0.5
                if rectForNextScroll.origin.x < 0 {
                    rectForNextScroll.origin.x = 0
                }
            }
            else if rect.intersects(rightBoundary) == true {
                rectForNextScroll.origin.x += self.bounds.size.width * 0.5
                if rectForNextScroll.origin.x > self.contentSize.width - self.bounds.size.width {
                    rectForNextScroll.origin.x = self.contentSize.width - self.bounds.size.width
                }
            }
            
        } else { // is vertical
            
            let topBoundary = CGRect(x: 0.0, y: -30.0, width: self.frame.size.width, height: 30.0)
            let bottomBoundary = CGRect(x: 0.0, y: self.frame.size.height, width: self.frame.size.width, height: 30.0)
            
            if rect.intersects(topBoundary) == true {
                rectForNextScroll.origin.y -= self.bounds.size.height * 0.5
                if rectForNextScroll.origin.y < 0 {
                    rectForNextScroll.origin.y = 0
                }
            }
            else if rect.intersects(bottomBoundary) == true {
                rectForNextScroll.origin.y += self.bounds.size.height * 0.5
                if rectForNextScroll.origin.y > self.contentSize.height - self.bounds.size.height {
                    rectForNextScroll.origin.y = self.contentSize.height - self.bounds.size.height
                }
            }
        }
        
        // check to see if a change in rectForNextScroll has been made
        if currentRect.equalTo(rectForNextScroll) == false {
            self.paging = true
            self.scrollRectToVisible(rectForNextScroll, animated: true)
            
            let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.paging = false
            }
            
        }
        
    }
    
    public func didMoveItem(_ item : AnyObject, inRect rect : CGRect) -> Void {
        
        let dragDropDS = self.dataSource as! KDDragAndDropCollectionViewDataSource // guaranteed to have a ds
        
        if  let existingIndexPath = dragDropDS.collectionView(self, indexPathForDataItem: item),
            let indexPath = self.indexPathForCellOverlappingRect(rect) {
            
            if indexPath.item != existingIndexPath.item {
                
                dragDropDS.collectionView(self, moveDataItemFromIndexPath: existingIndexPath, toIndexPath: indexPath)
                
                self.animating = true
                
                self.performBatchUpdates({ () -> Void in
                    self.moveItem(at: existingIndexPath, to: indexPath)
                }, completion: { (finished) -> Void in
                    self.animating = false
                    self.reloadData()
                    
                })
                
                self.draggingPathOfCellBeingDragged = indexPath
                
            }
        }
        
        // Check Paging
        
        var normalizedRect = rect
        normalizedRect.origin.x -= self.contentOffset.x
        normalizedRect.origin.y -= self.contentOffset.y
        
        currentInRect = normalizedRect
        
        
        self.checkForEdgesAndScroll(normalizedRect)
        
        
    }
    
    public func didMoveOutItem(_ item : AnyObject) -> Void {
        
        guard let dragDropDataSource = self.dataSource as? KDDragAndDropCollectionViewDataSource,
            let existngIndexPath = dragDropDataSource.collectionView(self, indexPathForDataItem: item) else {
                
                return
        }
        
        dragDropDataSource.collectionView(self, deleteDataItemAtIndexPath: existngIndexPath)
        
        if self.animating {
            self.deleteItems(at: [existngIndexPath])
        }
        else {
            self.animating = true
            self.performBatchUpdates({ () -> Void in
                self.deleteItems(at: [existngIndexPath])
            }, completion: { (finished) -> Void in
                self.animating = false;
                self.reloadData()
            })
            
        }
        
        if let idx = self.draggingPathOfCellBeingDragged {
            if let cell = self.cellForItem(at: idx) {
                cell.isHidden = false
            }
        }
        
        self.draggingPathOfCellBeingDragged = nil
        
        currentInRect = nil
    }
    
    
    public func dropDataItem(_ item : AnyObject, atRect : CGRect) -> Void {
        
        // show hidden cell
        if  let index = draggingPathOfCellBeingDragged,
            let cell = self.cellForItem(at: index), cell.isHidden == true {
            
            cell.alpha = 1
            cell.isHidden = false
            
        }
        
        currentInRect = nil
        
        self.draggingPathOfCellBeingDragged = nil
        
        self.reloadData()
        
    }
    
    
}



import UIKit

public protocol KDDraggable {
    func canDragAtPoint(_ point : CGPoint) -> Bool
    func representationImageAtPoint(_ point : CGPoint) -> UIView?
    func stylingRepresentationView(_ view: UIView) -> UIView?
    func dataItemAtPoint(_ point : CGPoint) -> AnyObject?
    func dragDataItem(_ item : AnyObject) -> Void
    
    /* optional */ func startDraggingAtPoint(_ point : CGPoint) -> Void
    /* optional */ func stopDragging() -> Void
}

extension KDDraggable {
    public func startDraggingAtPoint(_ point : CGPoint) -> Void {}
    public func stopDragging() -> Void {}
}


public protocol KDDroppable {
    func canDropAtRect(_ rect : CGRect) -> Bool
    func willMoveItem(_ item : AnyObject, inRect rect : CGRect) -> Void
    func didMoveItem(_ item : AnyObject, inRect rect : CGRect) -> Void
    func didMoveOutItem(_ item : AnyObject) -> Void
    func dropDataItem(_ item : AnyObject, atRect : CGRect) -> Void
}

public class KDDragAndDropManager: NSObject, UIGestureRecognizerDelegate {
    
    fileprivate var canvas : UIView = UIView()
    fileprivate var views : [UIView] = []
    fileprivate var longPressGestureRecogniser = UILongPressGestureRecognizer()
    
    
    struct Bundle {
        var offset : CGPoint = CGPoint.zero
        var sourceDraggableView : UIView
        var overDroppableView : UIView?
        var representationImageView : UIView
        var dataItem : AnyObject
    }
    var bundle : Bundle?
    
    public init(canvas : UIView, collectionViews : [UIView]) {
        
        super.init()
        
        self.canvas = canvas
        
        self.longPressGestureRecogniser.delegate = self
        self.longPressGestureRecogniser.minimumPressDuration = 0.3
        self.longPressGestureRecogniser.addTarget(self, action: #selector(KDDragAndDropManager.updateForLongPress(_:)))
        self.canvas.isMultipleTouchEnabled = false
        self.canvas.addGestureRecognizer(self.longPressGestureRecogniser)
        self.views = collectionViews
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        guard gestureRecognizer.state == .possible else { return false }
        
        for view in self.views where view is KDDraggable  {
            
            let draggable = view as! KDDraggable
            
            let touchPointInView = touch.location(in: view)
            
            guard draggable.canDragAtPoint(touchPointInView) == true else { continue }
            
            guard var representation = draggable.representationImageAtPoint(touchPointInView) else { continue }
            
            representation.frame = self.canvas.convert(representation.frame, from: view)
            representation.alpha = 0.5
            if let decoredView = draggable.stylingRepresentationView(representation) {
                representation = decoredView
            }
            
            let pointOnCanvas = touch.location(in: self.canvas)
            
            let offset = CGPoint(x: pointOnCanvas.x - representation.frame.origin.x, y: pointOnCanvas.y - representation.frame.origin.y)
            
            if let dataItem: AnyObject = draggable.dataItemAtPoint(touchPointInView) {
                
                self.bundle = Bundle(
                    offset: offset,
                    sourceDraggableView: view,
                    overDroppableView : view is KDDroppable ? view : nil,
                    representationImageView: representation,
                    dataItem : dataItem
                )
                
                return true
                
            }
            
        }
        
        return false
        
    }
    
    @objc public func updateForLongPress(_ recogniser : UILongPressGestureRecognizer) -> Void {
        
        guard let bundle = self.bundle else { return }
        
        let pointOnCanvas = recogniser.location(in: self.canvas)
        let sourceDraggable : KDDraggable = bundle.sourceDraggableView as! KDDraggable
        let pointOnSourceDraggable = recogniser.location(in: bundle.sourceDraggableView)
        
        switch recogniser.state {
            
            
        case .began :
            self.canvas.addSubview(bundle.representationImageView)
            sourceDraggable.startDraggingAtPoint(pointOnSourceDraggable)
            
        case .changed :
            
            // Update the frame of the representation image
            var repImgFrame = bundle.representationImageView.frame
            repImgFrame.origin = CGPoint(x: pointOnCanvas.x - bundle.offset.x, y: pointOnCanvas.y - bundle.offset.y);
            bundle.representationImageView.frame = repImgFrame
            
            var overlappingAreaMAX: CGFloat = 0.0
            
            var mainOverView: UIView?
            
            for view in self.views where view is KDDraggable  {
                
                let viewFrameOnCanvas = self.convertRectToCanvas(view.frame, fromView: view)
                

                let overlappingAreaCurrent = bundle.representationImageView.frame.intersection(viewFrameOnCanvas).area
                
                if overlappingAreaCurrent > overlappingAreaMAX {
                    
                    overlappingAreaMAX = overlappingAreaCurrent
                    
                    mainOverView = view
                }
                
                
            }
            
            
            
            if let droppable = mainOverView as? KDDroppable {
                
                let rect = self.canvas.convert(bundle.representationImageView.frame, to: mainOverView)
                
                if droppable.canDropAtRect(rect) {
                    
                    if mainOverView != bundle.overDroppableView { // if it is the first time we are entering
                        
                        (bundle.overDroppableView as! KDDroppable).didMoveOutItem(bundle.dataItem)
                        droppable.willMoveItem(bundle.dataItem, inRect: rect)
                    }
                    
                    // set the view the dragged element is over
                    self.bundle!.overDroppableView = mainOverView
                    
                    droppable.didMoveItem(bundle.dataItem, inRect: rect)
                    
                }
            }
            
            
        case .ended :
            
            if bundle.sourceDraggableView != bundle.overDroppableView { // if we are actually dropping over a new view.
                
                if let droppable = bundle.overDroppableView as? KDDroppable {
                    
                    sourceDraggable.dragDataItem(bundle.dataItem)
                    
                    let rect = self.canvas.convert(bundle.representationImageView.frame, to: bundle.overDroppableView)
                    
                    droppable.dropDataItem(bundle.dataItem, atRect: rect)
                    
                }
            }
            
            bundle.representationImageView.removeFromSuperview()
            sourceDraggable.stopDragging()
            
        default:
            break
            
        }
        
    }
    
    // MARK: Helper Methods
    func convertRectToCanvas(_ rect : CGRect, fromView view : UIView) -> CGRect {
        
        var r = rect
        var v = view
        
        while v != self.canvas {
            
            guard let sv = v.superview else { break; }
            
            r.origin.x += sv.frame.origin.x
            r.origin.y += sv.frame.origin.y
            
            v = sv
        }
        
        return r
    }
    
}


extension CGRect: Comparable {
    
    public var area: CGFloat {
        return self.size.width * self.size.height
    }
    
    public static func <=(lhs: CGRect, rhs: CGRect) -> Bool {
        return lhs.area <= rhs.area
    }
    public static func <(lhs: CGRect, rhs: CGRect) -> Bool {
        return lhs.area < rhs.area
    }
    public static func >(lhs: CGRect, rhs: CGRect) -> Bool {
        return lhs.area > rhs.area
    }
    public static func >=(lhs: CGRect, rhs: CGRect) -> Bool {
        return lhs.area >= rhs.area
    }
}


class DataItem: Equatable {
    var indexes: String
    var colour: UIColor
    
    init(_ indexes: String, _ colour: UIColor = UIColor.clear) {
        self.indexes = indexes
        self.colour = colour
    }
    
    static func ==(lhs: DataItem, rhs: DataItem) -> Bool {
        return lhs.indexes == rhs.indexes && lhs.colour == rhs.colour
    }
}

class ColorCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.frame = contentView.bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController, KDDragAndDropCollectionViewDataSource, UICollectionViewDelegate {
    
    var firstCollectionView: KDDragAndDropCollectionView!
    var secondCollectionView: KDDragAndDropCollectionView!
    var thirdCollectionView: KDDragAndDropCollectionView!
    
    var data: [[DataItem]] = []
    var dragAndDropManager: KDDragAndDropManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Generate mock data
        let colours = [UIColor.orange, UIColor.black, UIColor.gray]
        self.data = (0...2).map { i in (0...20).map { j in DataItem("\(i):\(j)", colours[i]) } }
        
        // Set up collection views
        setupCollectionViews()
        
        // Initialize drag-and-drop manager
        dragAndDropManager = KDDragAndDropManager(
            canvas: self.view,
            collectionViews: [firstCollectionView, secondCollectionView, thirdCollectionView]
        )
    }
    
    private func setupCollectionViews() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        firstCollectionView = createCollectionView(with: layout, tag: 0)
        secondCollectionView = createCollectionView(with: layout, tag: 1)
        thirdCollectionView = createCollectionView(with: layout, tag: 2)

        // Layout collection views
        let stackView = UIStackView(arrangedSubviews: [firstCollectionView, secondCollectionView, thirdCollectionView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 500) // Fixed height
        ])
    }
    
    private func createCollectionView(with layout: UICollectionViewFlowLayout, tag: Int) -> KDDragAndDropCollectionView {
        let collectionView = KDDragAndDropCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.tag = tag
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }

    // MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ColorCell
        let dataItem = data[collectionView.tag][indexPath.item]
        
        cell.label.text = "\(indexPath.item)\n\n\(dataItem.indexes)"
        cell.backgroundColor = dataItem.colour
        
        // Hide the cell being dragged
        if let kdCollectionView = collectionView as? KDDragAndDropCollectionView,
           let draggingPath = kdCollectionView.draggingPathOfCellBeingDragged, draggingPath.item == indexPath.item {
            cell.isHidden = true
        } else {
            cell.isHidden = false
        }
        
        return cell
    }

    // MARK: - KDDragAndDropCollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
        return data[collectionView.tag][indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem: AnyObject, atIndexPath indexPath: IndexPath) {
        if let di = dataItem as? DataItem {
            data[collectionView.tag].insert(di, at: indexPath.item)
            collectionView.reloadData() // Reload after insertion
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath: IndexPath) {
        data[collectionView.tag].remove(at: indexPath.item)
        collectionView.reloadData() // Reload after deletion
    }
    
    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to: IndexPath) {
        let fromDataItem = data[collectionView.tag][from.item]
        data[collectionView.tag].remove(at: from.item)
        data[collectionView.tag].insert(fromDataItem, at: to.item)
        collectionView.reloadData() // Reload after moving
    }
    
    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath? {
        guard let candidate = dataItem as? DataItem else { return nil }
        
        for (i, item) in data[collectionView.tag].enumerated() {
            if candidate == item {
                return IndexPath(item: i, section: 0)
            }
        }
        
        return nil
    }
}
