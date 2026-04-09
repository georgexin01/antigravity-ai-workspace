using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;
using System.Net.Sockets;

class OpenClaw {
    static void Main() {
        // DIAGNOSTIC HOOK: Confirm EXE has started
        // MessageBox.Show("OpenClaw Sovereign Portal: Initializing Components...", "OpenClaw Debug");

        string baseDir = AppDomain.CurrentDomain.BaseDirectory;
        string scriptPath = Path.Combine(baseDir, ".openclaw", "OpenClaw_GUI.ps1");
        
        if (!File.Exists(scriptPath)) {
            MessageBox.Show("CRITICAL ERROR: Sovereign GUI Script not found.\nExpected at: " + scriptPath, "OpenClaw Integrity Failure", MessageBoxButtons.OK, MessageBoxIcon.Error);
            return;
        }

        // Fast-Timeout Brain Check (1.0 Seconds)
        if (!IsOllamaRunning(1000)) {
            var result = MessageBox.Show(
                "Ollama (Local Brain) is currently unreachable on port 11434.\n\n" +
                "OpenClaw requires an active local brain to process sovereign data.\n\n" +
                "Would you like to force launch the GUI anyway?", 
                "OpenClaw: Brain Check", 
                MessageBoxButtons.YesNo, 
                MessageBoxIcon.Warning
            );
            if (result == DialogResult.No) return;
        }

        ProcessStartInfo psi = new ProcessStartInfo();
        psi.FileName = "powershell.exe";
        // Use -NoProfile and -ExecutionPolicy Bypass for maximum portability
        psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File \"" + scriptPath + "\"";
        
        // TEMPORARY: Remove Hidden style to allow PowerShell errors to show if they occur
        // psi.WindowStyle = ProcessWindowStyle.Hidden; 
        
        psi.UseShellExecute = false;
        psi.CreateNoWindow = false; // Set to false to see if the powershell window has errors

        try {
            Process.Start(psi);
        } catch (Exception ex) {
            MessageBox.Show("SOVEREIGN LAUNCH FAILURE:\n" + ex.Message + "\n\nStack: " + ex.StackTrace, "OpenClaw Crash Handler");
        }
    }

    static bool IsOllamaRunning(int timeoutMs) {
        try {
            using (TcpClient client = new TcpClient()) {
                var result = client.BeginConnect("127.0.0.1", 11434, null, null);
                bool success = result.AsyncWaitHandle.WaitOne(timeoutMs);
                if (success) {
                    client.EndConnect(result);
                    return true;
                }
                return false;
            }
        } catch {
            return false;
        }
    }
}
