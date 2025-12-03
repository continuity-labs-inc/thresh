import SwiftUI

struct WeeklyReflectionScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var dailyCaptures: [String] = [] // TODO: Replace with actual data model
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.vm.textPrimary)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Color.vm.surface))
                }
                
                Spacer()
                
                Text("Weekly Reflection")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.vm.textSecondary)
                
                Spacer()
                
                // Empty spacer for symmetry
                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 16)
            
            // Synthesis Mode Badge
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.vm.synthesis)
                
                Text("SYNTHESIS MODE")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.vm.synthesis)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.vm.synthesis.opacity(0.1))
            )
            .padding(.bottom, 24)
            
            // Progress Dots
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.vm.synthesis)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "eye.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    )
                
                Text("Review")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.vm.synthesis)
                
                Spacer()
                
                Circle()
                    .fill(Color.vm.surfaceSecondary)
                    .frame(width: 40, height: 40)
                
                Spacer()
                
                Circle()
                    .fill(Color.vm.surfaceSecondary)
                    .frame(width: 40, height: 40)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 32)
            
            // Empty State
            if dailyCaptures.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Text("Your captures from this week")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.vm.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Image(systemName: "camera")
                        .font(.system(size: 60))
                        .foregroundColor(Color.vm.textTertiary)
                        .padding(.vertical, 20)
                    
                    Text("No captures this week")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.vm.textPrimary)
                    
                    Text("Weekly synthesis works best with daily captures to draw from. Start capturing your moments to build material for reflection.")
                        .font(.system(size: 16))
                        .foregroundColor(Color.vm.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 8)
                    
                    Spacer()
                    
                    // Create a Capture Button - CLEAN STYLING
                    Button(action: createCapture) {
                        Text("Create a Capture")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Color.vm.capture)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            } else {
                // TODO: List of daily captures with selection
                Text("Daily captures will appear here")
                    .foregroundColor(Color.vm.textSecondary)
                Spacer()
            }
        }
        .background(Color.vm.background)
    }
    
    private func createCapture() {
        // TODO: Navigate to NewReflectionScreen
        dismiss()
    }
}

#Preview {
    WeeklyReflectionScreen()
}
