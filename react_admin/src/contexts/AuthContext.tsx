import React, { createContext, useContext, useState, ReactNode } from "react";

export type UserRole = "user" | "astrologer" | "admin";

interface AuthUser {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  avatar?: string;
  walletBalance: number;
}

interface AuthContextType {
  user: AuthUser | null;
  login: (email: string, password: string, role: UserRole) => void;
  signup: (name: string, email: string, password: string, role: UserRole) => void;
  logout: () => void;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType | null>(null);

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be within AuthProvider");
  return ctx;
};

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<AuthUser | null>(null);

  const login = (email: string, _password: string, role: UserRole) => {
    setUser({
      id: "mock-" + Math.random().toString(36).slice(2),
      name: role === "admin" ? "Admin" : role === "astrologer" ? "Pandit Sharma" : "Rahul Kumar",
      email,
      role,
      walletBalance: role === "user" ? 500 : role === "astrologer" ? 2500 : 0,
    });
  };

  const signup = (name: string, email: string, _password: string, role: UserRole) => {
    setUser({
      id: "mock-" + Math.random().toString(36).slice(2),
      name,
      email,
      role,
      walletBalance: 0,
    });
  };

  const logout = () => setUser(null);

  return (
    <AuthContext.Provider value={{ user, login, signup, logout, isAuthenticated: !!user }}>
      {children}
    </AuthContext.Provider>
  );
};
