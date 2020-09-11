////////////////////////////////////////////////////////////////////////////
//
// Copyright 2020 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#if canImport(SwiftUI)
import XCTest
import RealmSwift
import SwiftUI

@available(OSX 10.15, watchOS 6.0, iOS 13.0, iOSApplicationExtension 13.0, OSXApplicationExtension 10.15, tvOS 13.0, *)
class SwiftUITestCase: TestCase {
    var realm: Realm!

    override func setUp() {
        super.setUp()
        realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test"))
    }

    override func tearDown() {
        realm.invalidate()
        realm = nil
        super.tearDown()
    }

    struct TestViewContainer: View {
        @FetchObjects var someObjects: Results<SwiftIntObject>

        var body: some View {
            VStack { }
        }
    }

    func testSwiftUI() {
        let viewRealm = try! Realm()

        let view = TestViewContainer()

        try! viewRealm.write {
            viewRealm.create(SwiftIntObject.self, value: [1])
            viewRealm.create(SwiftIntObject.self, value: [2])
            viewRealm.create(SwiftIntObject.self, value: [3])
        }

        _ = view.environment(\.realmConfiguration, viewRealm.configuration)
        XCTAssertEqual(view.someObjects.count, 3)

        let view2 = TestViewContainer()

        try! viewRealm.write {
            viewRealm.create(SwiftIntObject.self, value: [1])
            viewRealm.create(SwiftIntObject.self, value: [2])
            viewRealm.create(SwiftIntObject.self, value: [3])
        }

        _ = view2.environment(\.realmConfiguration, viewRealm.configuration)
        XCTAssertEqual(view2.someObjects.count, 6)
    }
}

#endif // canImport(SwiftUI)
