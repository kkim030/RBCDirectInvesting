import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: AuthResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let response: AuthResponse = try await APIService.shared.post("/auth/login", body: LoginRequest(email: email, password: password))
            await APIService.shared.setToken(response.token)
            currentUser = response
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func demoLogin() async {
        isLoading = true
        errorMessage = nil
        do {
            let response: AuthResponse = try await APIService.shared.post("/auth/demo")
            await APIService.shared.setToken(response.token)
            currentUser = response
            isAuthenticated = true
        } catch {
            // Offline fallback — lets the app run without a backend (e.g. Appetize.io)
            let offline = AuthResponse(
                token: "demo-offline-token",
                userId: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                email: "demo@rbc.com",
                fullName: "Demo User"
            )
            await APIService.shared.setToken(offline.token)
            currentUser = offline
            isAuthenticated = true
        }
        isLoading = false
    }

    func register(email: String, password: String, fullName: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let response: AuthResponse = try await APIService.shared.post("/auth/register",
                body: RegisterRequest(email: email, password: password, fullName: fullName))
            await APIService.shared.setToken(response.token)
            currentUser = response
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func logout() {
        Task { await APIService.shared.setToken(nil) }
        currentUser = nil
        isAuthenticated = false
    }
}
