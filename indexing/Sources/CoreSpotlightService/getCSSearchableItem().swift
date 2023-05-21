//	Created by Leopold Lemmermann on 20.10.22.

extension Indexable {
  public func getCSSearchableItem(_ app: String? = nil) -> CSSearchableItem {
    CSSearchableItem(
      uniqueIdentifier: id.description,
      domainIdentifier: nil,
      attributeSet: getCSAttributes(app)
    )
  }

  func getCSAttributes(_ app: String?) -> CSSearchableItemAttributeSet {
    let attributes: CSSearchableItemAttributeSet
    if #available(iOS 14, macOS 11, *) {
      attributes = .init(contentType: .text)
    } else {
      attributes = .init(itemContentType: "public.text")
    }
    
    attributes.creator = app
    attributes.title = getTitle()
    attributes.contentDescription = getDetails()
    attributes.kind = Self.getDescription()
    attributes.accountIdentifier = getAccount()
    attributes.userCreated = getUserCreated() as NSNumber?
    attributes.supportsNavigation = getSupportsNavigation() as NSNumber?
    attributes.addedDate = getAddedDate()

    return attributes
  }
}
