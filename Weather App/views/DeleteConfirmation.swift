import UIKit

class DeleteConfirmation {
    static func showDeleteConfirmation(
        from viewController: UIViewController,
        for city: String,
        at indexPath: IndexPath,
        sourceView: UIView?,
        deleteAction: @escaping (IndexPath) -> Void
    ) {
        let alertController = UIAlertController(
            title: "Delete?",
            message: "Are you sure you want to delete \(city) from your cities?",
            preferredStyle: .actionSheet
        )

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            deleteAction(indexPath) 
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        if let popoverPresentationController = alertController.popoverPresentationController, let sourceView = sourceView {
            popoverPresentationController.sourceView = sourceView
            popoverPresentationController.sourceRect = sourceView.bounds
        }

        viewController.present(alertController, animated: true, completion: nil)
    }
}
