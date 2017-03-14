//
//  MainTableViewController.swift
//
// Copyright (c) 21/12/15. Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

/*
 * http://swift.gg/2016/04/26/pattern-matching-1/ ///< 模式匹配第一弹: switch, enums & where 子句
 **/

import UIKit

enum Direction {
    case North, South, East, West
}

// 可以很容易地切换枚举值
extension Direction: CustomStringConvertible {
    var description: String {
        switch self {
        case .North: return "↑"
        case .South: return "↓"
        case .East:  return "→"
        case .West:  return "←"
        }
    }
}

extension Media {
    var isFromJulesVerne: Bool {
        switch self {
        case .Book(title: _, author: "Jules Verne", year: _): return true
        case .Movie(title: _, director: "Jules Verne", year: _): return true
        default: return false
        }
    }
}


// MARK: - 一次绑定多种模式///<  尝试绑定相同名字和类型的变量时，这仍然是有意义的工作
extension Media {
    var mediaTitle2 :String {
        switch self {
        case let .Book(title: aTitle, author: _, year: _), let .Movie(title: aTitle, director: _, year: _) :
            return aTitle
        default:
            return ""
        }
    }
}


// MARK: - 使用没有参数标签的元组
extension Media {
    var mediaTitle3 :String {
        switch self {
        case let .Book(tuple):
            return tuple.title
        default:
            return ""
        }
    }
}

// MARK: - 作为附加的奖励，可以不用指定特定的元组来匹配任何关联值，所以下面三个表达式是相等的
extension Media {
    var mediaTitle4 :String {
        switch self {
        case .Book(_):
            return "matching a single tuple of associated values that we don't care about"
        case .Movie(_, _, _) :
            return "matching individual associated values that we don't care about either"
        case .WebSite(_) :
            return "not specifying the tuple at all"
        default:
            return "ERROR"
        }
    }
}

/// Media
///
/// - Book: Book
/// - Movie: Movie
/// - WebSite: WebSite
enum Media {
    case Book(title: String ,author: String ,year: String)
    case Movie(title: String ,director: String ,year: String)
    case WebSite(url: String)
    case Star(name: String, birthday: Int)
}

extension Media {
    var mediaTitle :String {
        switch self {
        case Media.Book(let title, let author, let year):
            return "This is a Book title is \(title) author is \(author) year is \(year)"
        case .Movie(let title, let director, let year) :
            return "This is a Movie title is \(title) director is \(director) year is \(year)"
        case .WebSite(let url) :
            return "This is a WebSite Url is \(url)"
        default:
            return "Error"
        }
    }
}

/// Person
struct Person {
    let name: String
}


func ~= (pattern: String, value: Person) -> Bool {
    return value.name == pattern
}

let p = Person(name: "zidane")

/// MainTableViewController
class MainTableViewController: UITableViewController {
    
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488

    let kRowsCount = 10
    
    var cellHeights = [CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCellHeightsArray()
        uiconfig()
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    func uiconfig() {
        switch p {
        case "zidane" :
            print("It is me")
        default :
            print("It is not me")
        }
        
        print("\"tom\" ~= p == \("tom" ~= p)")
        
        var res = "tom" ~= p
        
        print("res == \(res)")
        
        let m = Media.Book(title: "hamoleite", author: "shasibiya", year: "1787")
        if case Media.Book(let title, let author, let year) = m {
            
        }else {
            
        }
        
        if case let Media.Book(title, author, year) = m {
            
        }else {
            
        }
        
        if case let .Book(title: aTitle, author: anAuthor, year: aYear) = m{
            
        }else {
            
        }
        
        switch m {
        case Media.Book(_, _, _):
            print("this is a book");
        default:
            print("this is not a book");
        }
        
        let mT = m.mediaTitle
        print("mT = \(mT)")
        
        res = m.isFromJulesVerne
        print("res == \(res)")
        
        let man = Media.Star(name: "zidane", birthday: 1978)
        
        /// 错误的where clause
        /*
        if case let Media.Star(name: _, birthday: year) where year > 2000 = man {
            
        }else {
            
        }
 */
    }
    
    // MARK: configure
    func createCellHeightsArray() {
        for _ in 0...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
      guard case let cell as DemoCell = cell else {
        return
      }
      
      cell.backgroundColor = UIColor.clear
      
      if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight {
        cell.selectedAnimation(false, animated: false, completion:nil)
      } else {
        cell.selectedAnimation(true, animated: false, completion: nil)
      }
      
      cell.number = indexPath.row
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[(indexPath as NSIndexPath).row]
    }
    
    // MARK: Table vie delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight { // open cell
            cellHeights[(indexPath as NSIndexPath).row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[(indexPath as NSIndexPath).row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)

        
    }
}
