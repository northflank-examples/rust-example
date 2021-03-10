let mut app = tide::new();
app.at("/").get(|_| async { Ok("Hello, world!") });
app.listen("127.0.0.1:8080").await?;