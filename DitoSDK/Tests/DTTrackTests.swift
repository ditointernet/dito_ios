import XCTest
@testable import DitoSDK

class DTTrackTests: DTTestCase {

    func testInvalidAction() {
        let action = "Botao track pressionado"
        let expectedAction = action.split(separator: " ").joined(separator: "_").lowercased()

        let event = DTEvent(
            action: action,
            json: nil
        )

        XCTAssertTrue(event.action == expectedAction)
    }

    func testValidAction() {
        let action = "botao_track_pressionado"

        let event = DTEvent(
            action: action,
            json: nil
        )

        XCTAssertTrue(event.action == action)
    }

    func testJsonIntegrity() {

        let key1 = "name of User"
        let value1 = "Will cause and error"
        let key2 = "user_age"
        let value2 = 1

        let jsonDictionary: [String: Any] = [key1: value1, key2: value2]

        let expectedKey1 = key1.split(separator: " ").joined(separator: "_").uppercased()
        let expectedValue2 = "\(value2)"

    let event = DTEvent(json: nil)

        guard let data = event.data?.data(using: .utf8) else {
            assert(false, "Data in DTEvent is empty and that was not expecteded")
            return
        }

        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            XCTAssertNotNil(dictionary)
            XCTAssertNil(dictionary?[key1])
            XCTAssertNotNil(dictionary?[expectedKey1])
            XCTAssertTrue(dictionary?[expectedKey1] as? String == value1)
            XCTAssertTrue(dictionary?[key2] as? String == expectedValue2)
        } catch let error {
            assert(false, "\(error)")
        }
    }

    func testTrack() {
        let expect = expectation(description: "register track")

        let action = "botao_track_pressionado"

        let credentials = registerUser()

        let event = DTEvent(
            action: action,
            json: nil
        )

        DTInitialize.track(credentials: credentials, event: event)

        #warning("TODO: Wait for user register")
        expect.fulfill()

        #warning("TODO: Wait expectation")
        wait(for: [expect], timeout: timeout)

        #warning("TODO: Check if track was successfull")
    }
}

extension DTTrackTests {
    func registerUser() -> DTCredentials {

        let credentials = DTCredentials(id: "1020")

        let user = DTUser(
            name: "Rodrigo Maciel",
            gender: .masculino,
            email: "teste@teste.com.br",
            birthday: "16/06/1994",
            location: "São Paulo",
            createdAt: Date(),
            json: nil
        )

        DTInitialize.identify(credentials: credentials, data: user)
        return credentials
    }
}
