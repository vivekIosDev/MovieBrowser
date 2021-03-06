import XCTest
@testable import MovieBrowser

class HomeScreenTest: XCTestCase {
    
    let handler = FileHandler()
    let defaultsManager = UserDefaultsManager()
    
    var homeVM: HomeViewModel {
        return HomeViewModel(defaultsManager: UserDefaultsManager())
    }
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    // MovieListViewModel Test
    func testThatCheckMovieListEmptyOrNot_WhenAPIGetsCall() throws {
       
        let expectation = XCTestExpectation(description: "Movie List fetch")
        homeVM.nowPlayingMovies.bind { movies in
            if (movies?.first?.id != 0) {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 30)
    }
    
    // FileManager
    func testDocumentsDirectory() {
        print(handler.documentsDirectory)
        assert(!handler.documentsDirectory.absoluteString.isEmpty)
    }
    
    func testContentsOfDocumentDirectory() {
        assert(handler.flushDocumentsDirectory() == true)
    }
}
