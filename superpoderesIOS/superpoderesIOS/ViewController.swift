//
//  ViewController.swift
//  superpoderesIOS
//
//  Created by Ivan Llopis Guardado on 21/09/2020.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var initView: UIView!
    @IBOutlet weak var labelMaxPoints: UILabel!
    @IBOutlet weak var levelSelector: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initView.backgroundColor = UIColor.yellow
        self.initView.alpha = 0.65
        self.labelMaxPoints.text = "\(DataManager.shared.getMaxScore())"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let vc = segue.destination as? ViewGameController else {
            return
        }
        var level: Level
        switch levelSelector.selectedSegmentIndex {
        case 0:
            level = .easy
        case 1:
            level = .normal
        case 2:
            level = .hard
        default:
            level = .easy
        }
        
        vc.setLevel(level: level)
        
        
    }

    @IBAction func startGame(_ sender: Any) {
        self.performSegue(withIdentifier: DataManager.shared.segue_game_view_controller, sender: nil)
    }
    
}

