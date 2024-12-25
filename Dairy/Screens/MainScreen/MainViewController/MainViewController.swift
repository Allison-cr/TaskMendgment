import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController, UICollectionViewDelegate, UITableViewDelegate {


    // MARK: - UI Elements
    private lazy var dayCollectionView: UICollectionView = setupCollectionView()
    private lazy var taskCollectionView: UICollectionView = setupTaskCollectionView()
    private lazy var buttonAddTask: UIButton = setupButtonAddTask()
    private lazy var backgoundImage: UIImageView = setupBackgoundImage()
    private lazy var headerView: UIView = setupHeaderView()
    private lazy var monthLabel: UILabel = setupMonthLabel()
    private lazy var mainViewBackground: UIView = setupMainViewBackground()
    private lazy var scrollView: UIScrollView = setupScrollView()
    private lazy var timeColumn: UITableView = setupTimeColumn()
    
    // MARK: - Properties
    private let timeSlots: [String] = (0...23).map { String(format: "%02d:00", $0) }
    private var tasks: [TaskModel] = []
    private lazy var separatorView: UIView = setupSeparatorView()
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    // MARK: - Dependencies
     private let viewModel: MainViewModel
     private let disposeBag = DisposeBag()
     weak var coordinator: MainCoordinator?

    // MARK: - Initializers
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToToday()
        scrollToHour()
    }

    // MARK: - Bind rx depency
    private func bindCollectionView() {
        viewModel.dates
             .bind(to: dayCollectionView.rx.items(cellIdentifier: CalendarCell.reuseIdentifier, cellType: CalendarCell.self)) { index, date, cell in
                 let isSelected = Calendar.current.isDate(date, inSameDayAs: self.viewModel.selectedDate.value ?? Date())
                 cell.configure(date: date, isSelected: isSelected)
             }
             .disposed(by: disposeBag)
        
        dayCollectionView.rx.modelSelected(Date.self)
            .subscribe(onNext: { [weak self] selectedDate in
                guard let self = self else { return }
                self.viewModel.selectedDate.accept(selectedDate)
                self.dayCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        
        viewModel.taskArrayPerDay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tasks in
                guard let self = self else { return }
                self.tasks = tasks
                if let layout = self.taskCollectionView.collectionViewLayout as? CustomTaskLayout {
                    layout.updateTasks(tasks, viewModel.selectedDate.value ?? Date())
                }
                self.taskCollectionView.reloadData()

            })
            .disposed(by: disposeBag)

        viewModel.month
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
    }

    // MARK: Scroll to today
    private func scrollToToday() {
        guard let today = viewModel.selectedDate.value else { return }
        let index = viewModel.dates.value.firstIndex { viewModel.calendar.isDate($0, inSameDayAs: today) }
        guard let index else { return }
        
        DispatchQueue.main.async {
            self.dayCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: Scroll to hour
    private func scrollToHour() {
        let currentDate = Date()
        let currentHour = Calendar.current.component(.hour, from: currentDate)
        
        DispatchQueue.main.async {
            self.timeColumn.scrollToRow(at: IndexPath(row: currentHour, section: 0), at: .top, animated: true)
        }
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupUI () {
        bindCollectionView()
        setupLayout()
    }
    
    
    func setupLayout() {
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = self
        timeColumn.delegate = self
        view.insertSubview(backgoundImage, at: 0)
        NSLayoutConstraint.activate([
            backgoundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgoundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgoundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgoundImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
            ])
        setupBlurEffect()

        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height),
 
            buttonAddTask.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            buttonAddTask.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonAddTask.heightAnchor.constraint(equalToConstant: 48),
            buttonAddTask.widthAnchor.constraint(equalToConstant: 48),
            
            monthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            monthLabel.centerYAnchor.constraint(equalTo: buttonAddTask.centerYAnchor),
            
            dayCollectionView.topAnchor.constraint(equalTo: buttonAddTask.bottomAnchor),
            dayCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dayCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dayCollectionView.heightAnchor.constraint(equalToConstant: 80),
            
            separatorView.topAnchor.constraint(equalTo: dayCollectionView.bottomAnchor,constant: -2),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 2),
            
            mainViewBackground.topAnchor.constraint(equalTo: dayCollectionView.bottomAnchor, constant: 16),
            mainViewBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainViewBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainViewBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         
            taskCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            taskCollectionView.leadingAnchor.constraint(equalTo: timeColumn.trailingAnchor, constant: 8),
            taskCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.leadingAnchor.constraint(equalTo: mainViewBackground.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: mainViewBackground.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: mainViewBackground.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: mainViewBackground.bottomAnchor),
            
            timeColumn.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            timeColumn.widthAnchor.constraint(equalToConstant: 84),
            timeColumn.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 16),
            timeColumn.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - obj Action
private extension MainViewController {
    @objc private func showAddTaskPopup() {
        coordinator?.pushToAddTask()
    }
}

// MARK: - Setup UI
private extension MainViewController {

    func setupCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.reuseIdentifier)
        headerView.addSubview(collectionView)
        return collectionView
    }
    
    func setupTaskCollectionView() -> UICollectionView {
        let layout = CustomTaskLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        scrollView.addSubview(collectionView)
        return collectionView
    }
    
    func setupButtonAddTask() -> UIButton {
        let button = UIButton()
        let font = UIFont.systemFont(ofSize: 32)
        let configuration = UIImage.SymbolConfiguration(font: font)
        let image = UIImage(systemName: "plus", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showAddTaskPopup), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(button)
        return button
    }
    
    func setupHeaderView() -> UIView {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(uiView)
        return uiView
    }
    
    func setupBackgoundImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "back")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        return imageView
    }
    
    func setupMonthLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        return label
    }
    
    func setupMainViewBackground() -> UIView {
        let viewMain = UIView()
        viewMain.backgroundColor = .clear
        viewMain.translatesAutoresizingMaskIntoConstraints = false
        viewMain.layer.masksToBounds = true
        view.addSubview(viewMain)
        return viewMain
    }
    
    func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        mainViewBackground.addSubview(scrollView)
        return scrollView
    }
    
    func setupSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(view)
        return view
    }
}

// MARK: - Table
extension MainViewController: UITableViewDataSource {
    func setupTimeColumn() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TimeCell")
        tableView.rowHeight = 100
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        scrollView.addSubview(tableView)
        return tableView
    }
}

// MARK: - Configuration Table TimeColumn
extension MainViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSlots.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath)
        cell.textLabel?.text = timeSlots[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.textLabel?.textColor = .white
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        cell.textLabel?.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0).isActive = true
        cell.textLabel?.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 15).isActive = true
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - Synchronize collection/table scroll
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == taskCollectionView {
            timeColumn.contentOffset.y = scrollView.contentOffset.y
        }
        else if scrollView == timeColumn {
            taskCollectionView.contentOffset.y = scrollView.contentOffset.y
        }
    }
}

// MARK: - Configure Collection
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let task = tasks[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.reuseIdentifier, for: indexPath) as! TaskCell
        cell.configure(task: task)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.item]
        coordinator?.showTaskDetails(task: selectedTask)
    }
}

// MARK: Blur
private extension MainViewController {
    private func setupBlurEffect() {
        blurEffectView.frame = headerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgoundImage.addSubview(blurEffectView)
    }
}
