/* filepath: c:\Users\belat\OneDrive\Documents\GitHub\RemedyAI-Frontend\src\app\page.js */
import Link from "next/link";
import Image from "next/image";

export default function Home() {
  return (
    <div className="container">
      <Image 
        src="/logo.png" 
        alt="RemedyAI Logo" 
        width={300}
        height={120}
        className="logo"
        priority
      />
      <h1>Welcome to RemedyAI</h1>
      
      <div className="form">
        <Link href="/signin" className="btn">Sign In</Link>
        <Link href="/register" className="btn">Register</Link>
      </div>
    </div>
  );
}