import Foundation
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let PortfolioEntityName: String = "PortfolioEntity"

    @Published var savedEntitise: [PortfolioEntity] = []

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading CoreData \(error)")
            }
            self.getPortfolio()
        }
    }

    //MARK: - Public

    func updatePortfolio(coin: CoinModel, amount: Double) {
        if let entity = savedEntitise.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                self.update(entity: entity, amount: amount)
            } else {
                self.delete(entity: entity)
            }
        } else {
            self.add(coin: coin, amount: amount)
        }
    }

    //MARK: - Private

    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: PortfolioEntityName)
        do {
            savedEntitise = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entity \(error)")
        }
    }

    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        self.applyChanges()
    }

    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        self.applyChanges()
    }

    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        self.applyChanges()
    }

    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to CoreData \(error)")
        }
    }

    private func applyChanges() {
        self.save()
        self.getPortfolio()
    }

}
