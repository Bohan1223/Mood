import SwiftUI

struct ContentViewTest: View {
    @State private var quote: String = "加载名言..."
    
    // 调用 OpenAI API 获取名言
    func fetchQuote() {
        let apiKey = "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"  // 替换为你的 OpenAI API 密钥
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        // 请求体
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",  // 或者替换为 "gpt-4" 来使用 GPT-4
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": "Give me an inspirational quote."]
            ],
            "max_tokens": 100
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 将请求体编码为 JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error encoding request body: \(error)")
            return
        }
        
        // 发起请求
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching quote: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                // 打印原始响应
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response: \(jsonString)")
                }
                
                // 解析响应数据
                do {
                    let responseObject = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                    if let quoteText = responseObject.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) {
                        DispatchQueue.main.async {
                            self.quote = quoteText
                        }
                    }
                } catch {
                    print("Error parsing response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    var body: some View {
        VStack {
            Text(quote)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
//            Button(action: fetchQuote) {
//                Text("获取新名言")
//                    .font(.headline)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
        }
        .onAppear {
            fetchQuote()  // 页面加载时调用接口获取名言
        }
    }
}

// OpenAI API 响应结构
struct OpenAIResponse: Codable {
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let role: String
        let content: String
    }
    
    let choices: [Choice]
}


