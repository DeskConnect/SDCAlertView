import SDCAlertView

@available(iOS 9, *)
class TestsViewController: UITableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
            case 0:
                let alert = SDCAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
                alert.addAction(SDCAlertAction(title: "OK", style: .Default))
                alert.presentAnimated(true, completion: nil)

            case 1, 3:
                let alert = SDCAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
                alert.addAction(SDCAlertAction(title: "OK", style: .Default))
                alert.addAction(SDCAlertAction(title: "Cancel", style: .Preferred))
                alert.presentAnimated(true, completion: nil)

            case 2:
                let alert = SDCAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
                alert.addAction(SDCAlertAction(title: "OK", style: .Default))
                alert.addAction(SDCAlertAction(title: "Cancel", style: .Preferred))
                alert.shouldDismissHandler = { $0?.title == "Cancel" }
                alert.presentAnimated(true, completion: nil)

            case 4:
                let alert = SDCAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
                alert.addAction(SDCAlertAction(title: "OK", style: .Default))
                alert.addAction(SDCAlertAction(title: "Cancel", style: .Preferred))
                alert.addAction(SDCAlertAction(title: "Button", style: .Default))
                alert.presentAnimated(true, completion: nil)

            case 5:
                let alert = SDCAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
                alert.actionLayout = .Vertical
                alert.addAction(SDCAlertAction(title: "OK", style: .Default))
                alert.addAction(SDCAlertAction(title: "Cancel", style: .Preferred))
                alert.presentAnimated(true, completion: nil)

            case 6:
                let alert = SDCAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
                alert.actionLayout = .Horizontal
                alert.addAction(SDCAlertAction(title: "OK", style: .Default))
                alert.addAction(SDCAlertAction(title: "Cancel", style: .Preferred))
                alert.addAction(SDCAlertAction(title: "Button", style: .Default))
                alert.presentAnimated(true, completion: nil)

            case 7:
                let alert = SDCAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
                alert.addTextFieldWithConfigurationHandler { textField in
                    textField.text = "Sample text"
                }
                alert.addAction(SDCAlertAction(title: "OK", style: .Preferred))
                alert.presentAnimated(true, completion: nil)

            case 8:
                let alert = SDCAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
                let contentView = alert.contentView
                let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                spinner.translatesAutoresizingMaskIntoConstraints = false
                spinner.startAnimating()
                contentView.addSubview(spinner)
                spinner.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor).active = true
                spinner.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
                spinner.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
                alert.presentAnimated(true, completion: nil)
            
            default: break
        }
    }

}
