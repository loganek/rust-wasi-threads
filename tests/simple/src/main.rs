use colored::Colorize;
use std::cell::RefCell;
use std::thread;
use std::time::Duration;

thread_local! {
    static CNT: RefCell<usize> = RefCell::new(0);
}

fn counter() {
    for i in 1..10 {
        CNT.with(|cnt| {
            *cnt.borrow_mut() += 1;
            assert_eq!(*cnt.borrow(), i);
            println!(
                "hi number {} from the spawned thread {:?}!",
                (*cnt.borrow()).to_string().green(),
                thread::current().id()
            );
        });
        thread::sleep(Duration::from_millis(1000));
    }
}

fn main() {
    let mut threads = Vec::new();
    for _ in 1..5 {
        threads.push(thread::spawn(counter));
    }

    while threads.len() > 0 {
        let cur_thread = threads.remove(0);
        cur_thread.join().unwrap();
    }
}
