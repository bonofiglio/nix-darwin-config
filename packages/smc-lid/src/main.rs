use std::fs::File;
use std::io::{self, Read};
use std::os::unix::io::AsRawFd;

use ioctls::eviocgsw;

const SW_LID: u16 = 0;

fn get_device_event_file(devices: &str) -> Option<&str> {
    let smc_info = devices.split("\n\n").find(|d| {
        d.lines()
            .any(|l| l == "N: Name=\"Apple SMC power/lid events\"")
    })?;

    smc_info.lines().find_map(|l| match l.split_once(' ') {
        Some(("H:", rest)) => rest
            .split_whitespace()
            .find(|part| part.starts_with("event")),
        _ => None,
    })
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut devices = String::new();
    File::open("/proc/bus/input/devices")?.read_to_string(&mut devices)?;

    let event_file = get_device_event_file(&devices)
        .expect("Could not find `Apple SMC power/lid events` device file");

    let device = format!("/dev/input/{}", event_file);

    let file = File::open(&device).map_err(|e| match e.kind() {
        io::ErrorKind::PermissionDenied => {
            "You need administrator privileges to run this program".to_string()
        }
        io::ErrorKind::NotFound => format!("Device file {device} not found. Aborting."),
        _ => format!("Could not open device file {device}: {e}"),
    })?;
    let fd = file.as_raw_fd();

    let buf_len = ioctls::libc::KEY_MAX.div_ceil(8) as usize;
    let mut sw_bits = vec![0u8; buf_len];

    unsafe { eviocgsw(fd, sw_bits.as_mut_ptr(), buf_len) };
    let lid_open = (sw_bits[0] & (1 << SW_LID)) == 0;

    println!("{}", lid_open as u8);

    Ok(())
}
