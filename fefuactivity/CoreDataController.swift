//
//  CoreDataController.swift
//  fefuactivity
//
//  Created by Mike Litvin on 26.12.2021.
//

import Foundation

class CoreDataController {
    func fetch() throws -> [ActivityDataModel] {
        let context = CoreDataContainer.instance.context
        
        let request = ActivityDataModel.fetchRequest()
        
        let rawActivities = try context.fetch(request)
        
        return rawActivities
    }
    
    func saveActivity(_ distance: String,
                      _ duration: String,
                      _ activityType: String,
                      _ startDate: String,
                      _ startTime: String,
                      _ endTime: String) {
        
        let context = CoreDataContainer.instance.context
        
        let activity = ActivityDataModel(context: context)
        
        activity.type = activityType
        activity.date = startDate
        activity.distance = distance
        activity.startTime = startTime
        activity.endTime = endTime
        activity.duration = duration
        
        CoreDataContainer.instance.saveContext()
    }
}
