import Foundation
import WordPressKit

struct BuyPlanItem {
    let title: String
    let description: String
    let plan: RemotePlan_ApiVersion1_3
}

protocol BuyPlanViewControllerDelegate: AnyObject {
    func didSelectPlan(_ plan: RemotePlan_ApiVersion1_3)
}

class BuyPlanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let vm: BuyPlanViewModel
    weak var planDelegate: BuyPlanViewControllerDelegate?

    var items: [BuyPlanItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    init(blog: Blog) {
        self.vm = BuyPlanViewModel(blog: blog)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Items"
        view.backgroundColor = .white
        setupTableView()

        vm.getPlans { [weak self] plans in
            var supportedPlans = ["1009", "1003"]

            self?.items = plans
                .filter { supportedPlans.contains($0.planID ?? "") }
                .map {
                    BuyPlanItem(title: $0.productName ?? "Name", description: $0.formattedPrice ?? "", plan: $0)
            }
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BuyPlanItemCell.self, forCellReuseIdentifier: "BuyPlanItemCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuyPlanItemCell", for: indexPath) as! BuyPlanItemCell
        cell.configure(with: items[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plan = items[indexPath.row].plan

        dismiss(animated: true)
        planDelegate?.didSelectPlan(plan)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class BuyPlanItemCell: UITableViewCell {

    func configure(with item: BuyPlanItem) {

        textLabel?.text = item.title
        detailTextLabel?.text = "\(item.description)"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class BuyPlanViewModel {
    private let blog: Blog

    init(blog: Blog) {
        self.blog = blog
    }

    func getPlans(_ completion: @escaping ([RemotePlan_ApiVersion1_3]) -> Void) {
        guard let restAPI = blog.wordPressComRestApi(),
            let siteID = blog.dotComID?.intValue else {
                return
        }

        let remote_v1_3 = PlanServiceRemote_ApiVersion1_3(wordPressComRestApi: restAPI)
        remote_v1_3.getPlansForSite(
            siteID,
            success: { (plans) in
                completion(plans.availablePlans)
            },
            failure: { error in
                completion([])
            }
        )
    }
}
