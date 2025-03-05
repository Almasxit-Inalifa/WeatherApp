import UIKit

class CarouselFlowLayout: UICollectionViewFlowLayout {
    let scaleFactor: CGFloat = 0.8
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        scrollDirection = .horizontal
        itemSize = CGSize(width: collectionView.bounds.width * 0.75, height: collectionView.bounds.height * 0.9)
        minimumLineSpacing = 10
        
        let horizontalInset = (collectionView.bounds.width - itemSize.width) / 2
        sectionInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true 
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        
        let attributesArray = super.layoutAttributesForElements(in: rect)?
            .compactMap { $0.copy() as? UICollectionViewLayoutAttributes } ?? []
        
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        
        for attributes in attributesArray {
            let distance = abs(attributes.center.x - centerX)
            let scale = max(scaleFactor, 1 - (distance / collectionView.bounds.width * 0.3))
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        return attributesArray
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let centerX = proposedContentOffset.x + collectionView.bounds.width / 2
        let attributesArray = layoutAttributesForElements(in: collectionView.bounds) ?? []
        
        var closestAttributes: UICollectionViewLayoutAttributes?
        var closestDistance: CGFloat = .greatestFiniteMagnitude
        
        for attributes in attributesArray {
            let distance = abs(attributes.center.x - centerX)
            if distance < closestDistance {
                closestAttributes = attributes
                closestDistance = distance
            }
        }
        
        guard let nearestAttributes = closestAttributes else { return proposedContentOffset }
        let targetX = nearestAttributes.center.x - collectionView.bounds.width / 2
        return CGPoint(x: targetX, y: proposedContentOffset.y)
    }
}
