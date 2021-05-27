class Chat {
  final String name, lastMessage, image, time;
  final bool isActive;
  final int unRead;

  Chat({
    this.name,
    this.lastMessage,
    this.image,
    this.time,
    this.isActive,
    this.unRead,
  });
}

List chatsData = [
  Chat(
    name: "Jenny Wilson",
    lastMessage: "Hope you are doing well...",
    image: "assets/logo.png",
    time: "还有10分钟",
    isActive: false,
    unRead: 9,
  ),
  Chat(
    name: "Esther Howard",
    lastMessage: "Hello Abdullah! I am...",
    image: "assets/logo.png",
    time: "还有10分钟",
    isActive: true,
    unRead: 1,
  ),
  Chat(
    name: "Ralph Edwards",
    lastMessage: "Do you have update...",
    image: "assets/logo.png",
    time: "5d ago",
    isActive: false,
    unRead: 1,
  ),
  Chat(
    name: "Jacob Jones",
    lastMessage: "You’re welcome :)",
    image: "assets/logo.png",
    time: "5d ago",
    isActive: true,
    unRead: 1,
  ),
  Chat(
    name: "Albert Flores",
    lastMessage: "Thanks",
    image: "assets/logo.png",
    time: "6d ago",
    isActive: false,
    unRead: 1,
  ),
  Chat(
    name: "Jenny Wilson",
    lastMessage: "Hope you are doing well...",
    image: "assets/logo.png",
    time: "3m ago",
    isActive: false,
    unRead: 1,
  ),
  Chat(
    name: "Esther Howard",
    lastMessage: "Hello Abdullah! I am...",
    image: "assets/logo.png",
    time: "8m ago",
    isActive: true,
    unRead: 1,
  ),
  Chat(
    name: "Ralph Edwards",
    lastMessage: "Do you have update...",
    image: "assets/logo.png",
    time: "5d ago",
    isActive: false,
    unRead: 1,
  ),
];
