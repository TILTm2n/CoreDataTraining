//
//  TableViewController.swift
//  CoreDataApp
//
//  Created by Eugene on 17.12.2021.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var models: [Company] = []
    
    lazy var persistentContainer: NSPersistentContainer? = {
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        
        return delegate.persistentContainer
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchModels()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Custom methods
    
    @IBAction func addButtonPressed(_ sender: Any) {
        saveNewModel()
        tableView.reloadData()
    }
    
    func fetchModels(){
        guard let context = persistentContainer?.viewContext else {return}
        
        //можно насильно вытащить без do catch если уверен что ошибки не будет, не знаю зачем фетч нужен
        models = try! context.fetch(Company.fetchRequest()) as! [Company]
        tableView.reloadData()
    }
    
    func saveNewModel(){
        guard let context = persistentContainer?.viewContext else {return}
        
        let model = Company(context: context)
        model.name = "Custom Name"
        model.age = Int16(models.count)
        
        do{
            models.append(model)
            try context.save()
        }
        catch let error{
            print("error -> \(error)")
        }
        
    }
    
    func removeModel(at indexPath: IndexPath){
        guard let context = persistentContainer?.viewContext else {return}
        //определяем модельку которую будем удалять
        let model = models[indexPath.row]
        //удаляем из контекста
        context.delete(model)
        
        do{
            //удаляем из массива моделей
            models.remove(at: indexPath.row)
            //пытаемя сохранить удаление в БД
            try context.save()
        }//если что-то пошло не так выводим ошибку
        catch let error{
            print("error -> \(error)")
        }
        //и за тем удаляем строку из таблицы
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    func update(with indexPath: IndexPath){
        guard let context = persistentContainer?.viewContext else {return}
        
        let model = models[indexPath.row]
        
        model.name = "Selected model"
        
        tableView.reloadRows(at: [indexPath], with: .fade)
        
        do{
            models[indexPath.row] = model
            try context.save()
        }
        catch let error{
            print("error -> \(error)")
        }

    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return models.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let model = models[indexPath.row]
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = String(model.age)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            removeModel(at: indexPath)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        update(with: indexPath)
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
