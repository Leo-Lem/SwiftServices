//	Created by Leopold Lemmermann on 07.11.22.

@available(iOS 16, macOS 13, *)
func sleep(for duration: Duration) async {
  try? await Task.sleep(for: duration)
}
