//
//  ZLViewControllerSwift.swift
//  ZLUIKitPlus_Example
//
//  ZLUIKitPlus Demo 入口 — 列表导航到每个组件的详细 Demo 控制器
//

import UIKit
import ZLUIKitPlus

class ZLViewControllerSwift: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Demo 列表数据
    struct DemoItem {
        let title: String
        let subtitle: String
        let emoji: String
        let makeVC: () -> UIViewController
    }

    private let tableView = UITableView(frame: .zero, style: .plain)

    private lazy var items: [DemoItem] = [
        DemoItem(
            title: "Label",
            subtitle: "insets 内边距 — drawText / intrinsicContentSize / sizeThatFits / RTL 适配",
            emoji: "📝",
            makeVC: { ZLLabelDemoVC() }
        ),
        DemoItem(
            title: "View / ViewStyleable",
            subtitle: "gradColors / gradDirection / border / shadow / cornerRadii / radius",
            emoji: "🎨",
            makeVC: { ZLViewDemoVC() }
        ),
        DemoItem(
            title: "WrapperView",
            subtitle: "wrap(with:) / insets / insetsZero / contentView / ViewStyleable 样式",
            emoji: "📦",
            makeVC: { ZLWrapperViewDemoVC() }
        ),
        DemoItem(
            title: "Button",
            subtitle: "axis / contentOrder / align / spacing / flexibleSpacing / insets / imageSize / titleSize / imageMarge / titleMarge / tapInterval / imgTouchOnly / touchAreaEdgeInsets / ViewStyleable",
            emoji: "🔘",
            makeVC: { ZLButtonDemoVC() }
        ),
        DemoItem(
            title: "PairView 全部子类（12种）",
            subtitle: "PairLabelView / ImgLabelView / LabelImgView / PairImageView / PairButtonView / ImgButtonView / ButtonImgView / ButtonLabView / LabButtonView / ZLButtonStackView / StackViewButton / PairStackView",
            emoji: "🔗",
            makeVC: { ZLPairViewDemoVC() }
        ),
    ]

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ZLUIKitPlus Demo"
        view.backgroundColor = .white
        setupTableView()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DemoCell.self, forCellReuseIdentifier: DemoCell.id)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 72
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DemoCell.id, for: indexPath) as! DemoCell
        cell.configure(with: items[indexPath.row])
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = items[indexPath.row].makeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Demo Cell
private class DemoCell: UITableViewCell {
    static let id = "DemoCell"

    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let arrowLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        emojiLabel.font = .systemFont(ofSize: 28)
        emojiLabel.textAlignment = .center

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 1

        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.numberOfLines = 0

        arrowLabel.text = "›"
        arrowLabel.font = .systemFont(ofSize: 20)
        arrowLabel.textColor = .systemGray3

        [emojiLabel, titleLabel, subtitleLabel, arrowLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 36),

            arrowLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: arrowLabel.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),

            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
        ])
    }

    func configure(with item: ZLViewControllerSwift.DemoItem) {
        emojiLabel.text = item.emoji
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
}


