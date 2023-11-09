//
//  ViewController.swift
//  Factorial1
//
//  Created by Tekla Matcharashvili on 08.11.23.
//
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = UIColor.systemBlue

        let calculateButton = UIButton(type: .system)
        calculateButton.setTitle("Calculate Factorials", for: .normal)
        calculateButton.setTitleColor(UIColor.white, for: .normal)
        calculateButton.backgroundColor = UIColor.systemOrange
        calculateButton.layer.cornerRadius = 10
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
        calculateButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(calculateButton)

        NSLayoutConstraint.activate([
            calculateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calculateButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            calculateButton.widthAnchor.constraint(equalToConstant: 200),
            calculateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func calculateButtonTapped() {
        runFactorialCalculation()
    }

    func runFactorialCalculation() {
        let firstNumber = generateRandomNumber()
        let secondNumber = generateRandomNumber()

        let dispatchGroup = DispatchGroup()

        var winnerThread: String?
        var winnerFactorial: Decimal?

        dispatchGroup.enter()
        DispatchQueue.global().async {
            calculateFactorial(number: firstNumber) { result in
                print("Factorial of \(firstNumber): \(result)")
                if winnerFactorial == nil || result > winnerFactorial! {
                    winnerThread = "Thread 1"
                    winnerFactorial = result
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        DispatchQueue.global().async {
            calculateFactorial(number: secondNumber) { result in
                print("Factorial of \(secondNumber): \(result)")
                if winnerFactorial == nil || result > winnerFactorial! {
                    winnerThread = "Thread 2"
                    winnerFactorial = result
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            if let winner = winnerThread, let factorial = winnerFactorial {
                let alertController = UIAlertController(title: "Winner", message: "\(winner) is the winner with a factorial of \(factorial)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

func generateRandomNumber() -> Int {
    return Int.random(in: 20...50)
}

func calculateFactorial(number: Int, completion: @escaping (Decimal) -> Void) {
    var result: Decimal = 1
    for i in 2...number {
        result *= Decimal(i)
    }
    completion(result)
}
