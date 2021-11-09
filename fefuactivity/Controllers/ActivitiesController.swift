//
//  ActivitiesController.swift
//  fefuactivity
//
//  Created by Mike Litvin on 28.10.2021.
//

import UIKit

class ActivitiesController: UIViewController {
    
    let database: [ActivitiesTableSection] = {
        let yesterdayData: [ActivityModel] = [
            ActivityModel(
                distance: "14.32 км", duration: "1 час 42 минуты", descriptionName: "Велосипед", descriptionSrc: UIImage(systemName: "bicycle.circle.fill") ?? UIImage(), deltaTime: "14 часов назад", started: "14:49", finished: "16:31"
            ),
        ]
        let mayData: [ActivityModel] = [
            ActivityModel(
                distance: "14.32 км", duration: "1 час 42 минуты", descriptionName: "Велосипед", descriptionSrc: UIImage(systemName: "bicycle.circle.fill") ?? UIImage(), deltaTime: "14 часов назад", started: "11:49", finished: "13:31"
            ),
        ]
        return [
            ActivitiesTableSection(date: "Вчера", activities: yesterdayData),
            ActivitiesTableSection(date: "Май  2022 года", activities: mayData),
        ]
    }()
    
    @IBOutlet weak var listOfActivities: UITableView!
    @IBOutlet weak var titleActivitiesLabel: UILabel!
    @IBOutlet weak var descriptionActivitiesLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet var activitiesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Активности"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        activitiesView.backgroundColor = .systemGray6
        
        listOfActivities.isHidden = true
        listOfActivities.separatorStyle = .none
        listOfActivities.backgroundColor = .systemGray6
        
        listOfActivities.delegate = self
        listOfActivities.dataSource = self
        
        listOfActivities.register(UINib(nibName: "ActivityCellController", bundle: nil), forCellReuseIdentifier: "ActivityCellController")
    }
    
    @IBAction func isStartButtonTouched(_ sender: Any) {
        titleActivitiesLabel.isHidden = true
        descriptionActivitiesLabel.isHidden = true
        listOfActivities.isHidden = false
    }
    
}

extension ActivitiesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let details = ActivityDetailsController(nibName: "ActivityDetailsController", bundle: nil)
        details.activity = self.database[indexPath.section].activities[indexPath.row]
        navigationController?.pushViewController(details, animated: true)
    }
}

extension ActivitiesController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database[section].activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.database[indexPath.section].activities[indexPath.row]
        let cell = listOfActivities.dequeueReusableCell(withIdentifier: "ActivityCellController", for: indexPath)
        guard let topCell = cell as? ActivityCellController else {
            return UITableViewCell()
        }
        
        topCell.setCellStats(data)
        return topCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return database.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UILabel()
        sectionHeader.text = database[section].date
        sectionHeader.font = .boldSystemFont(ofSize: 20)
        return sectionHeader
    }
    
}
